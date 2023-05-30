/// The valign-image type is used to indicate vertical alignment for images and
/// graphics, so it does not include a baseline value. Defaults are
/// implementation-dependent.
class ValignImage {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  ValignImage(this._value);

}