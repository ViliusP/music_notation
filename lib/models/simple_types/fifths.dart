/// The fifths type represents the number of flats or sharps in a traditional key
/// signature. Negative numbers are used for flats and positive numbers for sharps,
/// reflecting the key's placement within the circle of fifths (hence the type
/// name).
class Fifths {
  int _value;

  int get value => _value;

  set value(int value) {
    // add any necessary validation here
    _value = value;
  }

  Fifths(this._value);

}