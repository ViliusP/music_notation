import 'package:collection/collection.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/notes/note_element.dart';
import 'package:music_notation/src/notation_painter/notes/stemming.dart';

/// Set of static methods to help calculating direction of stems
class Adjacency {
  /// Notes position
  static List<NoteheadPosition> determineNoteheadPositions(
    List<Note> notes,
    StemDirection stemDirection,
  ) {
    NoteheadPosition defaultPosition = NoteheadPosition.left;

    final sortedNotes = notes.sortedBy(
      (note) => NoteElement.determinePosition(note, null),
    );

    if (stemDirection == StemDirection.down) {
      defaultPosition = NoteheadPosition.right;
    }

    List<NoteheadPosition> positions = List.filled(
      notes.length,
      defaultPosition,
    );

    // Return earlier if it has no adjacent notes.
    if (!containsAdjacentNotes(sortedNotes)) {
      return positions;
    }

    ElementPosition? noteBeforePosition;
    List<Set<int>> groups = [];
    Set<int> group = {};
    for (var (i, note) in sortedNotes.indexed) {
      if (noteBeforePosition == null) {
        noteBeforePosition = NoteElement.determinePosition(note, null);
        group.add(i);
        continue;
      }
      ElementPosition position = NoteElement.determinePosition(note, null);
      if (position.distance(noteBeforePosition) == 1) {
        group.add(i);
      } else {
        if (group.length > 1) {
          groups.add(group);
        }
        group = {i};
      }
      noteBeforePosition = position;
    }
    if (group.length > 1) {
      groups.add(group);
    }

    for (var group in groups) {
      ElementPosition position = NoteElement.determinePosition(
        sortedNotes.first,
        null,
      );
      NoteheadPosition pos = NoteheadPosition.left; // Starting position
      if (position.distanceFromMiddle >= 0 && group.length % 2 != 0) {
        pos = NoteheadPosition.right;
      }
      for (var index in group) {
        positions[index] = pos;
        if (pos == NoteheadPosition.right) {
          pos = NoteheadPosition.left;
        } else if (pos == NoteheadPosition.left) {
          pos = NoteheadPosition.right;
        }
      }
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
}

/// Indicates the relative position of a notehead in relation to the stem.
enum NoteheadPosition {
  left,
  right;
}
