/// The on-off type is used for notation elements such as string mutes.
class OnOff {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  OnOff(this._value);

}