/// The mute type represents muting for different instruments, including brass,
/// winds, and strings. The on and off values are used for undifferentiated mutes.
/// The remaining values represent specific mutes.
class Mute {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  Mute(this._value);

}