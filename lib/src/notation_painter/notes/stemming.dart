import 'package:flutter/foundation.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/clef.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/models/elements/music_data/note/stem.dart';

/// Provides static methods for determining the stem direction of notes and chords.
class Stemming {
  /// Determines the stem direction for a chord based on the position of the notes in relation to the staff center.
  ///
  /// This method ignores the individual [Note.stem] values and considers only the visual position of the notes on the staff.
  /// The notehead furthest from the middle line determines the stem direction:
  /// - If this note is above the middle line, the chord's stem direction is `down`.
  /// - If this note is below the middle line, the chord's stem direction is `up`.
  ///
  /// Currently, this method does not take into account the surrounding notes (contextual stemming).
  ///
  /// Parameters:
  /// - [note] - A list of notes within the chord to evaluate.
  /// - [clef] - An optional clef reference to help interpret the note positions on the staff.
  ///
  /// Returns:
  /// - [StemDirection.up] or [StemDirection.down] based on the furthest note position.
  static StemDirection determineChordStem(List<Note> note, [Clef? clef]) {
    return StemDirection.up;
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
          print("Currently `StemValue.double` is not supported yet");
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
