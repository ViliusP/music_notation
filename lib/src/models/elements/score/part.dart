import 'package:flutter/foundation.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/attributes.dart';
import 'package:music_notation/src/models/elements/music_data/backup.dart';
import 'package:music_notation/src/models/elements/music_data/forward.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:music_notation/src/models/utilities/type_parsers.dart';
import 'package:music_notation/src/models/utilities/xml_sequence_validator.dart';
import 'package:music_notation/src/notation_painter/note_element.dart';
import 'package:xml/xml.dart';

import 'package:music_notation/src/models/elements/music_data/music_data.dart';

/// Top level of musical organization below the score partwise.
class Part {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //
  final List<Measure> measures;

  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  /// An IDREF back to a score part within the part list.
  final String id;

  Part({
    required this.measures,
    required this.id,
  });

  // Field(s): quantifier
  static const Map<String, XmlQuantifier> _xmlExpectedOrder = {
    'measure': XmlQuantifier.oneOrMore,
  };

  factory Part.fromXml(XmlElement xmlElement) {
    validateSequence(xmlElement, _xmlExpectedOrder);

    String? id = xmlElement.getAttribute("id");
    if (id == null || id.isEmpty) {
      throw MissingXmlAttribute(
        message: "non-empty 'id' attribute is required for 'part' element",
        xmlElement: xmlElement,
      );
    }

    final Iterable<Measure> measures = xmlElement
        .findElements('measure')
        .map((element) => Measure.fromXml(element));

    return Part(
      id: id,
      measures: measures.toList(),
    );
  }

  // TODO: implement and test.
  XmlElement toXml() {
    final builder = XmlBuilder();
    // builder.element('part', nest: () {
    //   for (var measure in measures) {
    //     builder.element(measure.toXml());
    //   }
    //   builder.attribute('part-attributes', id);
    // });
    return builder.buildDocument().rootElement;
  }

  int calculateStaves() {
    int? staves;
    for (var measure in measures) {
      for (var data in measure.data) {
        switch (data) {
          case Attributes _:
            staves = data.staves;
            if (staves != null) {
              return staves;
            }
        }
      }
    }
    return 1;
  }
}

/// Represents a single measure in a musical score, containing various musical data elements.
///
/// The `Measure` class holds a list of `MusicDataElement` instances, such as notes,
/// directions, attributes, and more, along with measure-specific attributes like
/// key signature and time signature.
class Measure {
  final List<MusicDataElement> data;

  /// Measure's notes.
  List<Note> get notes => data.whereType<Note>().toList();

  final MeasureAttributes attributes;

  Measure({
    required this.data,
    required this.attributes,
  });

  // Field(s): quantifier
  static const Map<String, XmlQuantifier> _xmlExpectedOrder = {
    'note|backup|forward|direction|attributes|harmony|figured-bass|print|sound|listening|barline|grouping|link|bookmark':
        XmlQuantifier.zeroOrMore,
  };

  factory Measure.fromXml(XmlElement xmlElement) {
    validateSequence(xmlElement, _xmlExpectedOrder);

    return Measure(
      data: xmlElement.childElements
          .map((childElement) => MusicDataElement.fromXml(childElement))
          .toList(),
      attributes: MeasureAttributes.fromXml(xmlElement),
    );
  }

  XmlElement toXml() {
    final builder = XmlBuilder();
    for (var element in data) {
      builder.element('measure', nest: element.toXml());
    }
    // builder.attribute('measure-attributes', attributes.toXml());
    return builder.buildDocument().rootElement;
  }

  /// Splits the current measure into multiple measures, each corresponding to a different staff.
  ///
  /// This method is particularly useful for handling multi-staff scores, ensuring that
  /// each staff's musical data is isolated into its own measure. Common elements that apply
  /// to all staves (such as attributes like key signatures) are duplicated across all
  /// resulting measures, while staff-specific elements are assigned to their respective measures.
  ///
  /// ### Parameters:
  /// - [staves]: The number of staves in the score. Determines how many separate measures
  ///            will be created.
  ///
  /// ### Returns:
  /// A list of [Measure] instances, each representing the musical data for a single staff.
  ///
  /// ### Example:
  /// ```dart
  /// Measure originalMeasure = // ... obtain or create a Measure instance
  /// List<Measure> perStaffMeasures = originalMeasure.splitPerStaff(2);
  /// // Now, perStaffMeasures[0] contains data for the first staff,
  /// // and perStaffMeasures[1] contains data for the second staff.
  /// ```
  List<Measure> splitPerStaff(int staves) {
    List<Measure> measures = List.generate(
      staves,
      (index) => Measure(data: [], attributes: attributes),
    );

    // Keeps track of the cumulative duration for timing adjustments.
    double durationSeek = 0;
    int? lastStaff;

    for (MusicDataElement e in data) {
      // Flag for checking if that element is common for both staves.
      bool commonElement = false;
      int? staff;
      double elementDuration = 0;

      switch (e) {
        case Note note:
          staff = note.staff ?? 1;
          if (!note.isChord) {
            elementDuration = NoteElement.determineDuration(note);
          }
          break;
        case Backup backup:
          elementDuration = -backup.duration;
          commonElement = true;
          break;
        case Forward forward:
          staff = forward.staff;
          elementDuration = forward.duration;
          break;
        case Attributes _:
          commonElement = true;
          break;
        default:
          commonElement = true;
      }

      if (commonElement) {
        for (var m in measures) {
          m.data.add(e);
        }
      }
      if (!commonElement && staff != null) {
        measures[staff - 1].data.add(e);
      }
      durationSeek += elementDuration;
      lastStaff = staff ?? lastStaff;
    }
    return measures;
  }
}

/// Attributes for the measure element.
class MeasureAttributes {
  /// Identifies the measure. Going from partwise to timewise, measures
  /// are grouped via this attribute. In partwise files, it should be the
  /// same for measures in different parts that share the same left barline.
  ///
  /// While often numeric, it does not have to be. Non-numeric values are typically
  /// used together with the implicit or non-controlling attributes being set
  /// to "yes". For a pickup measure, the number attribute is typically set to "0"
  /// and the implicit attribute is typically set to "yes".
  String number;

  /// Specifies an ID that is unique to the entire document.
  String? id;

  /// Set to true for measures where the measure number should never appear,
  /// such as pickup measures and the last half of mid-measure repeats.
  ///
  /// The value is "no" if not specified.
  bool implicit;

  /// Intended for use in multimetric music like the Don Giovanni minuet.
  ///
  /// If set to "yes", the left barline in this measure does not coincide
  /// with the left barline of measures in other parts.
  ///
  /// The value is "no" if not specified.
  bool nonControlling;

  /// Measure width specified in tenths.
  /// These are the global tenths specified in the [Scaling] element,
  /// not local tenths as modified by the staff-size.
  ///
  /// The width covers the entire measure from barline or system start to barline or system end.
  double? width;

  /// Specification of displayed measure numbers
  /// that are different than what is used in the number attribute.
  /// This attribute is ignored for measures where the implicit attribute is set to "yes".
  /// Further details about measure numbering can be specified using the measure-numbering element
  String? text;

  MeasureAttributes({
    required this.number,
    this.id,
    this.implicit = false,
    this.nonControlling = false,
    this.width,
    this.text,
  });

  factory MeasureAttributes.fromXml(XmlElement xmlElement) {
    String? number = xmlElement.getAttribute("number");
    if (number == null || number.isEmpty) {
      throw MissingXmlAttribute(
        message: "'measure' must have non-empty 'number' attribute",
        xmlElement: xmlElement,
      );
    }

    String? id = xmlElement.getAttribute("id");
    if (id?.isEmpty == true) {
      throw MissingXmlAttribute(
        message: "'measure' element's id cannot be empty",
        xmlElement: xmlElement,
      );
    }

    String? text = xmlElement.getAttribute("text");
    if (text?.trim().isEmpty == true) {
      throw MusicXmlFormatException(
        message: "'text' attribute in measure should be null or non-empty",
        xmlElement: xmlElement,
        source: text,
      );
    }

    String? rawWidth = xmlElement.getAttribute("width");
    double? width = double.tryParse(rawWidth ?? "");
    if (rawWidth != null && width == null) {
      throw MusicXmlFormatException(
        message: "'width' attribute in measure cannot be parsed",
        xmlElement: xmlElement,
        source: text,
      );
    }

    return MeasureAttributes(
      number: number,
      id: id,
      implicit: YesNo.fromXml(xmlElement, 'implicit') ?? false,
      nonControlling: YesNo.fromXml(xmlElement, 'non-controlling') ?? false,
      text: text,
      width: width,
    );
  }
}
