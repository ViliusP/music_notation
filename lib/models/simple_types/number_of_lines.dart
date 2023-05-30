/// The number-of-lines type is used to specify the number of lines in text
/// decoration attributes.
class NumberOfLines {
  int _value;

  int get value => _value;

  set value(int value) {
    // add any necessary validation here
    _value = value;
  }

  NumberOfLines(this._value);

}