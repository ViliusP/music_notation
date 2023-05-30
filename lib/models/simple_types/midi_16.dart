/// The midi-16 type is used to express MIDI 1.0 values that range from 1 to 16.
class Midi16 {
  int _value;

  int get value => _value;

  set value(int value) {
    // add any necessary validation here
    _value = value;
  }

  Midi16(this._value);

}