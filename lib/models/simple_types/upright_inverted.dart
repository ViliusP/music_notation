/// The upright-inverted type describes the appearance of a fermata element. The
/// value is upright if not specified.
class UprightInverted {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  UprightInverted(this._value);

}