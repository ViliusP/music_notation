/// The handbell-value type represents the type of handbell technique being notated.
class HandbellValue {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  HandbellValue(this._value);

}