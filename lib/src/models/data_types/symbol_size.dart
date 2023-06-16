import 'package:collection/collection.dart';

/// Indicates full, cue, grace-cue, or large size.
///
/// If not specified, the value is full for regular notes, grace-cue for notes that contain both <grace> and <cue> elements, and cue for notes that contain either a <cue> or a <grace> element, but not both.
enum SymbolSize {
  full,
  cue,
  graceCue,
  large;

  static const _map = {
    full: 'full',
    cue: 'cue',
    graceCue: 'grace-cue',
    large: 'large',
  };

  static SymbolSize? fromString(String str) {
    return _map.entries.firstWhereOrNull((e) => e.value == str)?.key;
  }

  @override
  String toString() => _map[this]!;
}
