/// The string-number type indicates a string number. Strings are numbered from high
/// to low, with 1 being the highest pitched full-length string.
class StringNumber {
  int _value;

  int get value => _value;

  set value(int value) {
    // add any necessary validation here
    _value = value;
  }

  StringNumber(this._value);

}