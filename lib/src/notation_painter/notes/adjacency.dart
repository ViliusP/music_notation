import 'package:collection/collection.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/notes/note_element.dart';
import 'package:music_notation/src/notation_painter/notes/stemming.dart';

/// A set of static methods to determine notehead positions in chords based on adjacency and stem direction.
class Adjacency {
  /// Determines the relative positions of noteheads within a chord based on stem direction and adjacency.
  ///
  /// [notes] - List of notes to determine relative notehead positions.
  /// [stemDirection] - Direction of the chord's stem, affecting notehead placement.
  ///
  /// Returns:
  /// A list of [NoteheadPosition] values (left or right) corresponding to the noteheads' positions.
  static List<NoteheadPosition> determineNoteheadPositions(
    List<Note> notes,
    StemDirection stemDirection,
  ) {
    // Default position is set based on the stem direction.
    NoteheadPosition defaultPosition = NoteheadPosition.left;
    if (stemDirection == StemDirection.down) {
      defaultPosition = NoteheadPosition.right;
    }

    final sortedNotes = notes.sortedBy(
      (note) => NoteElement.determinePosition(note, null),
    );

    // Initialize positions with the default position
    List<NoteheadPosition> positions = List.filled(
      notes.length,
      defaultPosition,
    );

    // Return immediately if there are no adjacent notes.
    if (!containsAdjacentNotes(sortedNotes)) {
      return positions;
    }

    // Group adjacent notes by their position on the staff
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

    // Determine notehead positions for each group based on adjacency and stem direction
    for (var group in groups) {
      NoteheadPosition pos = NoteheadPosition.left; // Starting position
      if (stemDirection == StemDirection.down && group.length % 2 != 0) {
        pos = NoteheadPosition.right;
      }
      for (var index in group) {
        positions[index] = pos;
        // Alternate positions to create the zigzag pattern for adjacent notes
        pos = (pos == NoteheadPosition.right)
            ? NoteheadPosition.left
            : NoteheadPosition.right;
      }
    }

    return positions;
  }

  /// Determines if the given list of notes contains adjacent notes.
  ///
  /// [notes] - List of notes to check for adjacency.
  ///
  /// Returns:
  /// `true` if any two notes in the list have a positional difference of 1 (i.e., an interval of a second).
  /// Otherwise, returns `false`.
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

/// Represents the relative position of a notehead in relation to the stem within a chord.
enum NoteheadPosition {
  left,
  right;
}
