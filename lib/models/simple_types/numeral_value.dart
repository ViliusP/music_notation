/// The numeral-value type represents a Roman numeral or Nashville number value as a
/// positive integer from 1 to 7.
class NumeralValue {
  int _value;

  int get value => _value;

  set value(int value) {
    // add any necessary validation here
    _value = value;
  }

  NumeralValue(this._value);

}