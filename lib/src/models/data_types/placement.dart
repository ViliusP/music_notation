import 'package:collection/collection.dart';

/// Indicates whether one element appears above or below another element.
enum Placement {
  /// This element appears above the reference element.
  above,

  /// This element appears below the reference element.
  below;

  static Placement? fromString(String value) {
    return Placement.values.firstWhereOrNull((v) => v.name == value);
  }

  @override
  String toString() => name;
}
