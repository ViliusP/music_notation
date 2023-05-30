/// The winged attribute indicates whether the repeat has winged extensions that
/// appear above and below the barline. The straight and curved values represent
/// single wings, while the double-straight and double-curved values represent
/// double wings. The none value indicates no wings and is the default.
class Winged {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  Winged(this._value);

}