import 'package:music_notation/src/notation_painter/models/element_position.dart';

/// Enumerates the possible placements of ledger lines in relation to a note.
/// Ledger lines can be positioned either above or below a note symbol.
enum LedgerPlacement {
  /// Indicates that the ledger line(s) is positioned above the note symbol.
  above,

  /// Indicates that the ledger line(s) is positioned below the note symbol.
  below,
}

/// Represents the configuration of ledger lines for a particular note or element.
class LedgerLines {
  /// The number of ledger lines needed for the note or element.
  final int count;

  /// The placement of the ledger lines relative to the note or element.
  final LedgerPlacement placement;

  /// Indicates whether the ledger line extends through or intersects the note's head.
  /// When set to `true`, the ledger line will pass through the note's head, which is typically
  /// seen for notes that are directly adjacent to the staff.
  final bool extendsThroughNote;

  LedgerLines({
    required this.count,
    required this.placement,
    required this.extendsThroughNote,
  });

  static LedgerLines? fromElementPosition(ElementPosition position) {
    const middleDistanceToOuterLine = 4;
    int distance = position.distanceFromMiddle;

    var placement = LedgerPlacement.below;
    // if positive
    if (!distance.isNegative) {
      placement = LedgerPlacement.above;
    }
    distance = distance.abs();

    if (distance <= middleDistanceToOuterLine + 1) return null;
    distance -= middleDistanceToOuterLine;

    return LedgerLines(
      count: (distance / 2).floor(),
      placement: placement,
      extendsThroughNote: ((distance / 2) % 1) == 0,
    );
  }

  /// Creates a copy of the current [LedgerLines] instance with optional modifications.
  LedgerLines copyWith({
    int? count,
    LedgerPlacement? placement,
    bool? extendsThroughNote,
  }) {
    return LedgerLines(
      count: count ?? this.count,
      placement: placement ?? this.placement,
      extendsThroughNote: extendsThroughNote ?? this.extendsThroughNote,
    );
  }

  @override
  String toString() =>
      '_LedgerLines(count: $count, placement: $placement, extendsThroughNote: $extendsThroughNote)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LedgerLines &&
        other.count == count &&
        other.placement == placement &&
        other.extendsThroughNote == extendsThroughNote;
  }

  @override
  int get hashCode =>
      count.hashCode ^ placement.hashCode ^ extendsThroughNote.hashCode;
}
