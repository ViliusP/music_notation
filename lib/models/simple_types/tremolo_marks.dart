/// The number of tremolo marks is represented by a number from 0 to 8: the same as
/// beam-level with 0 added.
class TremoloMarks {
  int _value;

  int get value => _value;

  set value(int value) {
    // add any necessary validation here
    _value = value;
  }

  TremoloMarks(this._value);

}