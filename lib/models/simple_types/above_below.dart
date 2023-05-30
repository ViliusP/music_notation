/// The above-below type is used to indicate whether one element appears above or
/// below another element.
class AboveBelow {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  AboveBelow(this._value);

}