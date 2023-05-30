/// The positive-decimal type specifies a positive decimal value.
class PositiveDecimal {
  double _value;

  double get value => _value;

  set value(double value) {
    // add any necessary validation here
    _value = value;
  }

  PositiveDecimal(this._value);

}