import 'package:collection/collection.dart';
import 'package:music_notation/music_notation.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/attributes.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/clef.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/time.dart';
import 'package:music_notation/src/models/elements/music_data/backup.dart';
import 'package:music_notation/src/models/elements/music_data/direction/direction.dart';
import 'package:music_notation/src/models/elements/music_data/forward.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/models/elements/score/part.dart';
import 'package:music_notation/src/notation_painter/clef_element.dart';
import 'package:music_notation/src/notation_painter/cursor_element.dart';
import 'package:music_notation/src/notation_painter/key_element.dart';
import 'package:music_notation/src/notation_painter/measure/measure_element.dart';
import 'package:music_notation/src/notation_painter/models/notation_context.dart';
import 'package:music_notation/src/notation_painter/notes/chord_element.dart';
import 'package:music_notation/src/notation_painter/notes/note_element.dart';
import 'package:music_notation/src/notation_painter/notes/rest_element.dart';
import 'package:music_notation/src/notation_painter/time_signature_element.dart';

import 'package:music_notation/src/models/elements/music_data/music_data.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/key.dart'
    as musicxml show Key;

class NotationWidgetization {
  /// Processes a note and determines if it should be rendered as a single note or part of a chord.
  static MeasureWidget? _processNote(
    Note note,
    NotationContext context,
    List<MusicDataElement> measureData,
    FontMetadata font,
    int? staff,
  ) {
    if (context.divisions == null) {
      throw ArgumentError(
        "Context or measure must have divisions in attributes element",
      );
    }
    if (staff != null && staff != note.staff) return null;

    List<Note> notes = [note];
    int i = 0;
    while (i < measureData.length) {
      var nextElement = measureData[i];
      if (nextElement is Note &&
          nextElement.chord != null &&
          (staff == null || staff == nextElement.staff)) {
        notes.add(nextElement);
        i++;
      } else {
        break;
      }
    }
    if (notes.length > 1) {
      return Chord.fromNotes(
        notes: notes,
        notationContext: context,
        font: font,
      );
    }

    if (note.form is Rest) {
      return RestElement.fromNote(
        note: note,
        context: context,
        font: font,
      );
    }
    return NoteElement.fromNote(
      note: note,
      clef: context.clef,
      font: font,
    );
  }

  static List<MeasureWidget> _processAttributes(
    Attributes element,
    int? staff,
    NotationContext notationContext,
    FontMetadata font,
  ) {
    List<MeasureWidget> attributes = [];
    // -----------------------------
    // Clef
    // -----------------------------
    if (element.clefs.isNotEmpty) {
      // TODO: Implement handling for multiple clefs per staff.
      if (element.clefs.length > 1 && staff == null) {
        throw UnimplementedError(
          "Multiple clef signs are not implemented in renderer yet",
        );
      }

      Clef? clef = element.clefs.firstWhereOrNull(
        (element) => staff != null ? element.number == staff : true,
      );

      if (clef != null) {
        notationContext = notationContext.copyWith(
          clef: clef,
          divisions: element.divisions,
        );
        attributes.add(ClefElement(clef: clef, font: font));
      }
    }
    // -----------------------------
    // Keys
    // -----------------------------
    var keys = element.keys;
    if (keys.isEmpty) return attributes;
    musicxml.Key? musicKey;
    if (keys.length == 1 && keys.first.number == null) {
      musicKey = keys.first;
    }
    if (staff != null && keys.length > 1) {
      musicKey = keys.firstWhereOrNull(
        (element) => element.number == staff,
      );
    }
    if (musicKey == null) {
      throw ArgumentError(
        "There are multiple keys elements in attributes, therefore correct staff must be provided",
      );
    }
    var keySignature = KeySignatureElement.fromKeyData(
      keyData: musicKey,
      notationContext: notationContext,
      font: font,
    );
    if (keySignature.accidentals.isNotEmpty) {
      attributes.add(keySignature);
    }
    // -----------------------------
    // Time
    // -----------------------------

    for (var times in element.times) {
      switch (times) {
        case TimeBeat _:
          var timeBeatWidget = TimeSignatureElement(
            timeBeat: times,
            font: font,
          );
          attributes.add(timeBeatWidget);
          break;
        case SenzaMisura _:
          throw UnimplementedError(
            "Senza misura is not implemented in renderer yet",
          );
      }
    }
    return attributes;
  }

  static NotationContext _contextAfterAttributes(
    Attributes element,
    int? staff,
    NotationContext notationContext,
  ) {
    Clef? clef = element.clefs.firstWhereOrNull(
      (element) => staff != null ? element.number == staff : true,
    );

    return notationContext.copyWith(
      clef: clef,
      divisions: element.divisions,
    );
  }

  /// Builds a list of [MeasureWidget]s based on the provided measure data and notation context.
  ///
  /// - [context]: The current notation context.
  /// - [staff]: The staff number to filter elements (optional).
  /// - [measure]: The measure data containing musical elements.
  ///
  /// Returns a list of [MeasureWidget]s representing the musical elements within the measure.
  static List<MeasureWidget> widgetsFromMeasure({
    required NotationContext contextBefore,
    required int? staff,
    required Measure measure,
    required FontMetadata font,
  }) {
    NotationContext context = contextBefore.copyWith();

    final children = <MeasureWidget>[];
    for (int i = 0; i < measure.data.length; i++) {
      var element = measure.data[i];
      switch (element) {
        case Note note:
          var noteWidget = _processNote(
            note,
            context,
            measure.data.sublist(i + 1),
            font,
            staff,
          );
          if (noteWidget != null) {
            children.add(noteWidget);
          }
          if (noteWidget is Chord) {
            i += noteWidget.notes.length - 1;
          }
          break;
        case Backup backup:
          children.add(CursorElement(duration: -backup.duration));
          break;
        case Forward forward:
          if (staff != forward.staff) break;
          children.add(CursorElement(
            duration: forward.duration,
            voice: forward.editorialVoice.voice,
            staff: forward.staff,
          ));
          break;
        case Direction _:
          break;
        case Attributes attributes:
          var attributesWidgets = _processAttributes(
            element,
            staff,
            context,
            font,
          );
          context = _contextAfterAttributes(
            attributes,
            staff,
            context,
          );
          context = context.copyWith(divisions: attributes.divisions);
          children.addAll(attributesWidgets);
          break;
        // case Harmony _:
        //   break;
        // case FiguredBass _:
        //   break;
        // case Print _:
        //   break;
        // case Sound _:
        //   break;
        // case Listening _:
        //   break;
        // case Barline _:
        //   break;
        // case Grouping _:
        //   break;
        // case Link _:
        //   break;
        // case Bookmark _:
        //   break;
      }
    }
    return children;
  }
}
