/// The font-style type represents a simplified version of the CSS font-style
/// property.
class FontStyle {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  FontStyle(this._value);

}