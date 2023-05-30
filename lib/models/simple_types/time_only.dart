/// The time-only type is used to indicate that a particular playback- or
/// listening-related element only applies particular times through a repeated
/// section. The value is a comma-separated list of positive integers arranged in
/// ascending order, indicating which times through the repeated section that the
/// element applies.
class TimeOnly {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  TimeOnly(this._value);

}