import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/models/elements/music_data/note/stem.dart';
import 'package:music_notation/src/notation_painter/notes/simple_note_element.dart';

/// Provides static methods for determining the stem direction of notes and chords.
class Stemming {
  /// Default stem direction preference in ambiguous cases where the direction can be chosen flexibly.
  static const _defaultStemDirection = StemDirection.down;

  /// Determines the stem direction for a chord based on the position of the notes relative to the center of the staff.
  ///
  /// This method ignores [Note.stem] values and considers only the visual positions of the notes on the staff.
  /// The notehead furthest from the middle line determines the stem direction:
  /// - If this note is above the middle line, the chord's stem direction is `down`.
  /// - If this note is below the middle line, the chord's stem direction is `up`.
  ///
  /// This method does not currently account for surrounding notes (contextual stemming).
  ///
  /// Parameters:
  /// - [notes] - A list of notes within the chord to evaluate.
  ///
  /// Returns:
  /// - [StemDirection.up] or [StemDirection.down] based on the furthest note position.
  static StemDirection determineChordStemDirection(
      List<StemlessNoteElement> notes) {
    final sortedNotes = notes.sortedBy((note) => note.position);

    int distanceFromMiddleFirst = sortedNotes.first.position.distanceFromMiddle;

    int distanceFromMiddleLast = sortedNotes.last.position.distanceFromMiddle;

    // When the outer notes are both above or both below the middle line,
    // the stem direction is down if the notes are above, and up if the notes are below.
    if (distanceFromMiddleFirst.sign == distanceFromMiddleLast.sign) {
      if (distanceFromMiddleFirst.sign == 1) {
        return StemDirection.down;
      }
      if (distanceFromMiddleFirst.sign == -1) {
        return StemDirection.up;
      }
    }

    if (distanceFromMiddleFirst.abs() > distanceFromMiddleLast.abs()) {
      return StemDirection.up;
    }
    if (distanceFromMiddleFirst.abs() < distanceFromMiddleLast.abs()) {
      return StemDirection.down;
    }

    // When the outer notes are equidistant from the middle line, the stem direction
    // is determined by the majority of notes above or below the middle line.
    if (distanceFromMiddleFirst.abs() == distanceFromMiddleLast.abs() &&
        notes.length > 2) {
      var (below, above) = _countByMiddle(notes);

      /// Stem direction is up if the majority of notes are below the middle line.
      if (below > above) {
        return StemDirection.up;
      }

      /// Stem direction is down if the majority of notes are above the middle line.
      if (above > below) {
        return StemDirection.down;
      }
    }

    // When all notes in the chord are equidistant from the middle line, the stem can
    // follow the default direction set in [_defaultStemDirection].
    return _defaultStemDirection;
  }

  /// Counts the number of notes above and below the middle line in the given [notes] list.
  ///
  /// Parameters:
  /// - [notes] - A list of notes to evaluate.
  ///
  /// Returns:
  /// - A tuple containing the counts of notes below and above the middle line.
  static (int below, int above) _countByMiddle(
      List<StemlessNoteElement> notes) {
    int below = 0;
    int above = 0;
    for (var note in notes) {
      int distanceFromMiddle = note.position.distanceFromMiddle;
      if (distanceFromMiddle.sign == -1) {
        below += 1;
      }
      if (distanceFromMiddle.sign == 1) {
        above += 1;
      }
    }
    return (below, above);
  }
}

/// Enum representing the direction of the note stem.
enum StemDirection {
  up,
  down;

  /// Returns a [StemDirection] based on the [StemValue] provided.
  ///
  /// If [StemValue.double] is given, it currently defaults to [StemDirection.up]
  /// and prints a debug message indicating that `double` stems are not yet supported.
  ///
  /// Parameters:
  /// - [value] - The [StemValue] indicating the intended stem direction.
  ///
  /// Returns:
  /// - [StemDirection.up] if [StemValue.up] is provided.
  /// - [StemDirection.down] if [StemValue.down] is provided.
  /// - `null` if [StemValue.none] is provided.
  ///
  /// Notes:
  /// - Currently, [StemValue.double] is unsupported.
  static StemDirection? fromStemValue(StemValue value) {
    switch (value) {
      case StemValue.double:
        if (kDebugMode) {
          print("Currently `StemValue.double` is not supported.");
        }
        return up;
      case StemValue.none:
        return null;
      case StemValue.up:
        return up;
      case StemValue.down:
        return down;
    }
  }
}
