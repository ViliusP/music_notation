/// The degree-type-value type indicates whether the current degree element is an
/// addition, alteration, or subtraction to the kind of the current chord in the
/// harmony element.
class DegreeTypeValue {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  DegreeTypeValue(this._value);

}