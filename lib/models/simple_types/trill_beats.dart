/// The trill-beats type specifies the beats used in a trill-sound or bend-sound
/// attribute group. It is a decimal value with a minimum value of 2.
class TrillBeats {
  double _value;

  double get value => _value;

  set value(double value) {
    // add any necessary validation here
    _value = value;
  }

  TrillBeats(this._value);

}