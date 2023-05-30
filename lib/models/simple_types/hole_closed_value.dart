/// The hole-closed-value type represents whether the hole is closed, open, or
/// half-open.
class HoleClosedValue {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  HoleClosedValue(this._value);

}