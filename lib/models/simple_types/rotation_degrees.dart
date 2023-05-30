/// The rotation-degrees type specifies rotation, pan, and elevation values in
/// degrees. Values range from -180 to 180.
class RotationDegrees {
  double _value;

  double get value => _value;

  set value(double value) {
    // add any necessary validation here
    _value = value;
  }

  RotationDegrees(this._value);

}