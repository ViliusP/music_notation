/// The measure-text type is used for the text attribute of measure elements. It has
/// at least one character. The implicit attribute of the measure element should be
/// set to "yes" rather than setting the text attribute to an empty string.
class MeasureText {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  MeasureText(this._value);

}