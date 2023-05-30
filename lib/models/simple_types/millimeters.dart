/// The millimeters type is a number representing millimeters. This is used in the
/// scaling element to provide a default scaling from tenths to physical units.
class Millimeters {
  double _value;

  double get value => _value;

  set value(double value) {
    // add any necessary validation here
    _value = value;
  }

  Millimeters(this._value);

}