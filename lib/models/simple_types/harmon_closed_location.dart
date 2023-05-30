/// The harmon-closed-location type indicates which portion of the symbol is filled
/// in when the corresponding harmon-closed-value is half.
class HarmonClosedLocation {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  HarmonClosedLocation(this._value);

}