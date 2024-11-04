import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/notes/note_element.dart';

/// Set of static methods to help calculating direction of stems
class Adjacency {
  /// Notes position
  /// !!!!!!! notes must be sorted, lowest note is first.
  static List<NoteheadPosition> determineNoteheadPositions(
    List<Note> notes,
    StemDirection stemDirection,
  ) {
    NoteheadPosition defaultPosition = NoteheadPosition.left;

    if (stemDirection == StemDirection.down) {
      defaultPosition = NoteheadPosition.right;
    }

    List<NoteheadPosition> positions = List.filled(
      notes.length,
      defaultPosition,
    );

    // Return earlier if it has no adjacent notes.
    if (!containsAdjacentNotes(notes)) {
      return positions;
    }

    ElementPosition? noteBeforePosition;
    List<Set<int>> groups = [];
    Set<int> group = {};
    for (var (i, note) in notes.indexed) {
      if (noteBeforePosition == null) {
        noteBeforePosition = NoteElement.determinePosition(note, null);
        group.add(i);
        continue;
      }
      ElementPosition position = NoteElement.determinePosition(note, null);
      if (position.distance(noteBeforePosition) == 1) {
        group.add(i);
      } else if (group.length > 1) {
        groups.add(group);
        print(groups);
        group.clear();
      } else {
        group.clear();
      }
      noteBeforePosition = position;
    }

    return positions;
  }

  /// Checks if the chord contains adjacent notes, where two or more notes have a positional difference of 1.
  ///
  /// In musical terms, this indicates that there are two notes in the chord with
  /// an interval of a second (either minor or major).
  ///
  /// Returns `true` if the notes in the chord are adjacent; otherwise, returns `false`.
  static bool containsAdjacentNotes(List<Note> notes) {
    ElementPosition? noteBeforePosition;

    for (var note in notes) {
      if (noteBeforePosition == null) {
        noteBeforePosition = NoteElement.determinePosition(note, null);
        continue;
      }
      ElementPosition position = NoteElement.determinePosition(note, null);
      if (position.distance(noteBeforePosition) == 1) {
        return true;
      }
      noteBeforePosition = position;
    }

    return false;
  }

  /// Determines the lowest note position in a chord with adjacent notes,
  /// returning either [_NoteheadPosition.left] or [_NoteheadPosition.right].
  ///
  /// This function returns `null` if the chord does not contain adjacent notes,
  /// as there is no specific lowest note position in that case.
  ///
  /// Returns:
  /// - `null` if the chord does not contain adjacent notes.
  /// - [_NoteheadPosition.right] if the chord has an odd number of notes and a downward stem.
  /// - [_NoteheadPosition.left] in any other case.
  // _NoteheadPosition? get _lowestNotePosition {
  //   if (!_hasAdjacentNotes) return null;

  //   // If the chord has an odd number of notes and the stem is down,
  //   // the lowest note is positioned to the right.
  //   if (notes.length % 2 != 0 && stem?.value == StemValue.down) {
  //     return _NoteheadPosition.right;
  //   }

  //   return _NoteheadPosition.left;
  // }
}

/// Indicates the relative position of a notehead in relation to the stem.
enum NoteheadPosition {
  left,
  right;
}
