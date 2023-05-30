/// The breath-mark-value type represents the symbol used for a breath mark.
class BreathMarkValue {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  BreathMarkValue(this._value);

}