/// The comma-separated-text type is used to specify a comma-separated list of text
/// elements, as is used by the font-family attribute.
class CommaSeparatedText {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  CommaSeparatedText(this._value);

}