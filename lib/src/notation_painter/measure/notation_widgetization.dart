import 'package:collection/collection.dart';
import 'package:music_notation/music_notation.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/attributes.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/clef.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/key.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/time.dart';
import 'package:music_notation/src/models/elements/music_data/backup.dart';
import 'package:music_notation/src/models/elements/music_data/direction/direction.dart';
import 'package:music_notation/src/models/elements/music_data/forward.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/models/elements/score/part.dart';
import 'package:music_notation/src/notation_painter/cursor_element.dart';
import 'package:music_notation/src/notation_painter/measure/measure_element.dart';
import 'package:music_notation/src/notation_painter/models/notation_context.dart';
import 'package:music_notation/src/notation_painter/notes/chord_element.dart';

import 'package:music_notation/src/models/elements/music_data/music_data.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/key.dart'
    as musicxml show Key;

class NotationWidgetization {
  /// Processes a note and determines if it should be rendered as a single note or part of a chord.
  static MeasureElement? _processNote(
    Note note,
    NotationContext context,
    List<MusicDataElement> measureData,
    FontMetadata font,
    int? staff,
  ) {
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
      return MeasureElement.chord(
        notes: notes,
        font: font,
        clef: context.clef,
      );
    }

    if (note.form is Rest) {
      return MeasureElement.rest(rest: note, clef: context.clef, font: font);
    }
    return MeasureElement.note(note: note, clef: context.clef, font: font);
  }

  static List<MeasureElement> _processAttributes(
    Attributes element,
    int? staff,
    NotationContext notationContext,
    FontMetadata font,
  ) {
    List<MeasureElement> attributes = [];
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
        attributes.add(MeasureElement.clef(clef: clef, font: font));
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

    if (musicKey is TraditionalKey) {
      var keySignature = MeasureElement.keySignature(
        key: musicKey,
        font: font,
        keyBefore: notationContext.key,
        clef: notationContext.clef,
      );
      if (!keySignature.size.isEmpty) {
        attributes.add(
          MeasureElement.keySignature(
            key: musicKey,
            font: font,
            keyBefore: notationContext.key,
            clef: notationContext.clef,
          ),
        );
      }
    }
    if (musicKey is NonTraditionalKey) {
      throw UnimplementedError(
        "Non traditional key is not implemented in renderer yet",
      );
    }
    // -----------------------------
    // Time
    // -----------------------------

    for (var times in element.times) {
      switch (times) {
        case TimeBeat timeBeat:
          attributes.add(
            MeasureElement.timeSignature(timeBeat: timeBeat, font: font),
          );
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

  /// Builds a list of [MeasureElement]s based on the provided [measure] data and notation [context].
  ///
  /// - [context] - The notation context before [measure] start.
  /// - [staff] - The staff number to filter elements (optional).
  /// - [measure] - The measure data containing musical elements.
  ///
  /// Returns a list of [MeasureElement]s representing the musical elements within the measure.
  static List<MeasureElement> widgetsFromMeasure({
    required NotationContext context,
    required int? staff,
    required Measure measure,
    required FontMetadata font,
  }) {
    NotationContext newContext = context.copyWith();

    final children = <MeasureElement>[];
    for (int i = 0; i < measure.data.length; i++) {
      var element = measure.data[i];
      switch (element) {
        case Note note:
          var noteWidget = _processNote(
            note,
            newContext,
            measure.data.sublist(i + 1),
            font,
            staff,
          );
          if (noteWidget != null) {
            children.add(noteWidget);
          }
          if (noteWidget != null && noteWidget.child is Chord) {
            i += (noteWidget.child as Chord).notes.length - 1;
          }
          break;
        case Backup backup:
          var cursor = CursorElement(duration: -backup.duration);
          children.add(
            MeasureElement(
              position: cursor.position,
              size: cursor.baseSize,
              alignmentOffset: cursor.alignmentPosition,
              duration: cursor.duration,
              child: cursor,
            ),
          );
          break;
        case Forward forward:
          if (staff != forward.staff) break;
          var cursor = CursorElement(
            duration: forward.duration,
            voice: forward.editorialVoice.voice,
            staff: forward.staff,
          );
          children.add(
            MeasureElement(
              position: cursor.position,
              size: cursor.baseSize,
              alignmentOffset: cursor.alignmentPosition,
              duration: cursor.duration,
              child: cursor,
            ),
          );
          break;
        case Direction _:
          break;
        case Attributes attributes:
          var attributesWidgets = _processAttributes(
            element,
            staff,
            newContext,
            font,
          );
          newContext = _contextAfterAttributes(
            attributes,
            staff,
            newContext,
          );
          newContext = newContext.copyWith(divisions: attributes.divisions);
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
