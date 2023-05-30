/// The css-font-size type includes the CSS font sizes used as an alternative to a
/// numeric point size.
class CssFontSize {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  CssFontSize(this._value);

}