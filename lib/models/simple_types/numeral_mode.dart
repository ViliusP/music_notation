/// The numeral-mode type specifies the mode similar to the mode type, but with a
/// restricted set of values. The different minor values are used to interpret
/// numeral-root values of 6 and 7 when present in a minor key. The harmonic minor
/// value sharpens the 7 and the melodic minor value sharpens both 6 and 7. If a
/// minor mode is used without qualification, either in the mode or numeral-mode
/// elements, natural minor is used.
class NumeralMode {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  NumeralMode(this._value);

}