/// The font-weight type represents a simplified version of the CSS font-weight
/// property.
class FontWeight {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  FontWeight(this._value);

}