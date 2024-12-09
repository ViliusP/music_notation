import 'package:collection/collection.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/notes/stemming.dart';

/// A set of static methods to determine notehead positions in chords based on adjacency and stem direction.
class Adjacency {
  /// Determines the relative positions of noteheads within a chord based on stem direction and adjacency.
  ///
  /// [positions] - List of positions to determine relative notehead positions.
  /// [stemDirection] - Direction of the chord's stem, affecting notehead placement.
  ///
  /// Returns:
  /// A list of [NoteheadSide] values (left or right) corresponding to the noteheads' positions.
  static List<NoteheadSide> determineNoteSides(
    List<ElementPosition> positions,
    StemDirection stemDirection,
  ) {
    // Default position is set based on the stem direction.
    NoteheadSide defaultPosition = NoteheadSide.left;
    if (stemDirection == StemDirection.down) {
      defaultPosition = NoteheadSide.right;
    }

    final sortedPositions = positions.sortedBy((position) => position);

    // Initialize positions with the default position
    List<NoteheadSide> sides = List.filled(
      positions.length,
      defaultPosition,
    );

    // Return immediately if there are no adjacent notes.
    if (!containsAdjacentNotes(sortedPositions)) {
      return sides;
    }

    // Group adjacent notes by their position on the staff
    ElementPosition? positionBefore;
    List<Set<int>> groups = [];
    Set<int> group = {};
    for (var (i, position) in positions.indexed) {
      if (positionBefore == null) {
        positionBefore = position;
        group.add(i);
        continue;
      }
      if (position.distance(positionBefore) == 1) {
        group.add(i);
      } else {
        if (group.length > 1) {
          groups.add(group);
        }
        group = {i};
      }
      positionBefore = position;
    }
    if (group.length > 1) {
      groups.add(group);
    }

    // Determine notehead positions for each group based on adjacency and stem direction
    for (var group in groups) {
      NoteheadSide side = NoteheadSide.left; // Starting position
      if (stemDirection == StemDirection.down && group.length % 2 != 0) {
        side = NoteheadSide.right;
      }
      for (var index in group) {
        sides[index] = side;
        // Alternate positions to create the zigzag pattern for adjacent notes
        side = (side == NoteheadSide.right)
            ? NoteheadSide.left
            : NoteheadSide.right;
      }
    }

    return sides;
  }

  /// Determines if the given list of notes contains adjacent notes.
  ///
  /// [positions] - List of positions to check for adjacency.
  ///
  /// Returns:
  /// `true` if any two notes in the list have a positional difference of 1 (i.e., an interval of a second).
  /// Otherwise, returns `false`.
  static bool containsAdjacentNotes(List<ElementPosition> positions) {
    if (positions.length < 2) return false;
    ElementPosition lastPosition = positions.first;

    for (var position in positions.skip(1)) {
      if (position.distance(lastPosition) == 1) {
        return true;
      }
      lastPosition = position;
    }

    return false;
  }
}

/// Represents the relative position of a notehead in relation to the stem within a chord.
enum NoteheadSide {
  left,
  right;
}
