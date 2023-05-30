/// The milliseconds type represents an integral number of milliseconds.
class Milliseconds {
  int _value;

  int get value => _value;

  set value(int value) {
    // add any necessary validation here
    _value = value;
  }

  Milliseconds(this._value);

}