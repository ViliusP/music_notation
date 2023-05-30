/// The midi-16384 type is used to express MIDI 1.0 values that range from 1 to
/// 16,384.
class Midi16384 {
  int _value;

  int get value => _value;

  set value(int value) {
    // add any necessary validation here
    _value = value;
  }

  Midi16384(this._value);

}