/// The positive-divisions type restricts divisions values to positive numbers.
class PositiveDivisions {
  double _value;

  double get value => _value;

  set value(double value) {
    // add any necessary validation here
    _value = value;
  }

  PositiveDivisions(this._value);

}