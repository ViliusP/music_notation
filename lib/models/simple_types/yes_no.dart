/// The yes-no type is used for boolean-like attributes. We cannot use W3C XML
/// Schema booleans due to their restrictions on expression of boolean values.
class YesNo {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  YesNo(this._value);

}