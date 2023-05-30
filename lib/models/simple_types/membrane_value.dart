/// The membrane-value type represents pictograms for membrane percussion
/// instruments.
class MembraneValue {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  MembraneValue(this._value);

}