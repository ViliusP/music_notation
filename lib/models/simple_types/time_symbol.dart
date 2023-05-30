/// The time-symbol type indicates how to display a time signature. The normal value
/// is the usual fractional display, and is the implied symbol type if none is
/// specified. Other options are the common and cut time symbols, as well as a
/// single number with an implied denominator. The note symbol indicates that the
/// beat-type should be represented with the corresponding downstem note rather than
/// a number. The dotted-note symbol indicates that the beat-type should be
/// represented with a dotted downstem note that corresponds to three times the
/// beat-type value, and a numerator that is one third the beats value.
class TimeSymbol {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  TimeSymbol(this._value);

}