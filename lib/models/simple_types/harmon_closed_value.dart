/// The harmon-closed-value type represents whether the harmon mute is closed, open,
/// or half-open.
class HarmonClosedValue {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  HarmonClosedValue(this._value);

}