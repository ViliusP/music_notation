import 'package:collection/collection.dart';

/// Indicates whether one element appears above or below another element.
enum Placement {
  /// Element appears above the reference element.
  above,

  /// Element appears below the reference element.
  below;

  static Placement? fromString(String value) {
    return Placement.values.firstWhereOrNull((v) => v.name == value);
  }

  @override
  String toString() => name;
}
