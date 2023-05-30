/// The caesura-value type represents the shape of the caesura sign.
class CaesuraValue {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  CaesuraValue(this._value);

}