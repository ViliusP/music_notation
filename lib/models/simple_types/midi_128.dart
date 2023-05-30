/// The midi-128 type is used to express MIDI 1.0 values that range from 1 to 128.
class Midi128 {
  int _value;

  int get value => _value;

  set value(int value) {
    // add any necessary validation here
    _value = value;
  }

  Midi128(this._value);

}