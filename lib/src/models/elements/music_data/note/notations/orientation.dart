import 'package:collection/collection.dart';

/// The orientation attribute indicates whether slurs and ties are overhand
/// (tips down) or underhand (tips up). This is distinct from the placement
/// attribute used by any notation type.
enum Orientation {
  /// Tips of curved lines are overhand (tips down).
  over,

  /// Tips of curved lines are underhand (tips up).
  under;

  static Orientation? fromString(String value) {
    return Orientation.values.firstWhereOrNull((v) => v.name == value);
  }

  @override
  String toString() => name;
}
