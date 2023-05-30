/// The hole-closed-location type indicates which portion of the hole is filled in
/// when the corresponding hole-closed-value is half.
class HoleClosedLocation {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  HoleClosedLocation(this._value);

}