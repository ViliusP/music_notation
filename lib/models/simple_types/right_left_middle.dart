/// The right-left-middle type is used to specify barline location.
class RightLeftMiddle {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  RightLeftMiddle(this._value);

}