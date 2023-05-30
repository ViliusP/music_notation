/// The percent type specifies a percentage from 0 to 100.
class Percent {
  double _value;

  double get value => _value;

  set value(double value) {
    // add any necessary validation here
    _value = value;
  }

  Percent(this._value);

}