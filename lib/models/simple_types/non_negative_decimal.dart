/// The non-negative-decimal type specifies a non-negative decimal value.
class NonNegativeDecimal {
  double _value;

  double get value => _value;

  set value(double value) {
    // add any necessary validation here
    _value = value;
  }

  NonNegativeDecimal(this._value);

}