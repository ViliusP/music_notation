/// The bar-style type represents barline style information. Choices are regular,
/// dotted, dashed, heavy, light-light, light-heavy, heavy-light, heavy-heavy, tick
/// (a short stroke through the top line), short (a partial barline between the 2nd
/// and 4th lines), and none.
class BarStyle {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  BarStyle(this._value);

}