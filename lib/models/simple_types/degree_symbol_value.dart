/// The degree-symbol-value type indicates which symbol should be used in specifying
/// a degree.
class DegreeSymbolValue {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  DegreeSymbolValue(this._value);

}