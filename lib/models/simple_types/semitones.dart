/// The semitones type is a number representing semitones, used for chromatic
/// alteration. A value of -1 corresponds to a flat and a value of 1 to a sharp.
/// Decimal values like 0.5 (quarter tone sharp) are used for microtones.
class Semitones {
  double _value;

  double get value => _value;

  set value(double value) {
    // add any necessary validation here
    _value = value;
  }

  Semitones(this._value);

}