/// Octaves are represented by the numbers 0 to 9, where 4 indicates the octave
/// started by middle C.
class Octave {
  int _value;

  int get value => _value;

  set value(int value) {
    // add any necessary validation here
    _value = value;
  }

  Octave(this._value);

}