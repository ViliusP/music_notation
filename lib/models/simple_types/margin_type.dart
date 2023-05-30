/// The margin-type type specifies whether margins apply to even page, odd pages, or
/// both.
class MarginType {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  MarginType(this._value);

}