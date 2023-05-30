/// The valign type is used to indicate vertical alignment to the top, middle,
/// bottom, or baseline of the text. If the text is on multiple lines, baseline
/// alignment refers to the baseline of the lowest line of text. Defaults are
/// implementation-dependent.
class Valign {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  Valign(this._value);

}