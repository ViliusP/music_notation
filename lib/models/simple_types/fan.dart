/// The fan type represents the type of beam fanning present on a note, used to
/// represent accelerandos and ritardandos.
class Fan {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  Fan(this._value);

}