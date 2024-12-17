import 'package:flutter/rendering.dart';
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

/// Represents the configuration of ledger lines for a specific note or element.
class LedgerLines {
  /// The number of ledger lines needed for the note or element.
  final int count;

  /// The placement of the first ledger line relative to the note or element.
  final LedgerPlacement start;

  /// The direction in which the ledger lines are drawn from the starting point.
  /// Lines are repeated upward or downward.
  ///
  /// if [direction] is [VerticalDirection.up] ledger lines are drawn upwards from the starting point.
  /// if [direction] is [VerticalDirection.down] Ledger lines are drawn downwards from the starting point.
  final VerticalDirection direction;

  /// Constructs a [LedgerLines] instance with the specified [count], [start], and [direction].
  const LedgerLines({
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
    if (position >= ElementPosition.topFirstLedger) {
      int distance = position.distance(ElementPosition.topFirstLedger);

      return LedgerLines(
          count: (distance / 2).floor() + 1,
          direction: VerticalDirection.down,
          start: distance % 2 == 0
              ? LedgerPlacement.center
              : LedgerPlacement.below);
    }

    if (position <= ElementPosition.bottomFirstLedger) {
      int distance = position.distance(ElementPosition.bottomFirstLedger);

      return LedgerLines(
          count: (distance / 2).floor() + 1,
          direction: VerticalDirection.up,
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
    VerticalDirection? direction,
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
