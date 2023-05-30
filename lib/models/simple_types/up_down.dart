/// The up-down type is used for the direction of arrows and other pointed symbols
/// like vertical accents, indicating which way the tip is pointing.
class UpDown {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  UpDown(this._value);

}