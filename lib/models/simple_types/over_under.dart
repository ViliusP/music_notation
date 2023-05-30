/// The over-under type is used to indicate whether the tips of curved lines such as
/// slurs and ties are overhand (tips down) or underhand (tips up).
class OverUnder {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  OverUnder(this._value);

}