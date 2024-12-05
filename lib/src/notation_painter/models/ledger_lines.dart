import 'package:music_notation/src/notation_painter/models/element_position.dart';

/// Enumerates the possible placements of ledger lines in relation to a note.
/// Ledger lines can be positioned above, below, or centered on a note symbol.
enum LedgerPlacement {
  /// Indicates that the ledger line is positioned above the note symbol.
  above,

  /// Indicates that the ledger line is positioned below the note symbol.
  below,

  /// Indicates that the ledger line is positioned at the center of the note symbol.
  center;
}

/// Specifies the direction in which ledger lines are drawn from the note.
/// Lines are repeated upward or downward.
enum LedgerDrawingDirection {
  /// Ledger lines are drawn upwards from the starting point.
  up,

  /// Ledger lines are drawn downwards from the starting point.
  down;
}

/// Represents the configuration of ledger lines for a specific note or element.
class LedgerLines {
  /// The number of ledger lines needed for the note or element.
  final int count;

  /// The placement of the first ledger line relative to the note or element.
  final LedgerPlacement start;

  /// The direction in which the ledger lines are drawn from the starting point.
  final LedgerDrawingDirection direction;

  /// Constructs a [LedgerLines] instance with the specified [count], [start], and [direction].
  LedgerLines({
    required this.count,
    required this.start,
    required this.direction,
  });

  /// Creates a [LedgerLines] instance based on the [ElementPosition].
  ///
  /// Determines the number, placement, and direction of the ledger lines required
  /// for a note or element depending on its position relative to the middle line
  /// of the staff.
  ///
  /// - Returns `null` if no ledger lines are required for the position.
  static LedgerLines? fromElementPosition(ElementPosition position) {
    if (position >= ElementPosition.firstLedgerAbove) {
      int distance = position.distance(ElementPosition.firstLedgerAbove);

      return LedgerLines(
          count: (distance / 2).floor() + 1,
          direction: LedgerDrawingDirection.down,
          start: distance % 2 == 0
              ? LedgerPlacement.center
              : LedgerPlacement.below);
    }

    if (position <= ElementPosition.firstLedgerBelow) {
      int distance = position.distance(ElementPosition.firstLedgerBelow);

      return LedgerLines(
          count: (distance / 2).floor() + 1,
          direction: LedgerDrawingDirection.up,
          start: distance % 2 == 0
              ? LedgerPlacement.center
              : LedgerPlacement.above);
    }

    return null;
  }

  /// Creates a copy of the current [LedgerLines] instance with optional modifications.
  ///
  /// - [count]: The number of ledger lines.
  /// - [start]: The placement of the first ledger line.
  /// - [direction]: The drawing direction of the ledger lines.
  LedgerLines copyWith({
    int? count,
    LedgerPlacement? start,
    LedgerDrawingDirection? direction,
  }) {
    return LedgerLines(
      count: count ?? this.count,
      start: start ?? this.start,
      direction: direction ?? this.direction,
    );
  }

  @override
  String toString() =>
      '_LedgerLines(count: $count, start: $start, direction: $direction)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LedgerLines &&
        other.count == count &&
        other.start == start &&
        other.direction == direction;
  }

  @override
  int get hashCode => count.hashCode ^ start.hashCode ^ direction.hashCode;
}
