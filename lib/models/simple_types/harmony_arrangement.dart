/// The harmony-arrangement type indicates how stacked chords and bass notes are
/// displayed within a harmony element. The vertical value specifies that the second
/// element appears below the first. The horizontal value specifies that the second
/// element appears to the right of the first. The diagonal value specifies that the
/// second element appears both below and to the right of the first.
class HarmonyArrangement {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  HarmonyArrangement(this._value);

}