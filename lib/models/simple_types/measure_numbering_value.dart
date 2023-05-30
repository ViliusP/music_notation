/// The measure-numbering-value type describes how measure numbers are displayed on
/// this part: no numbers, numbers every measure, or numbers every system.
class MeasureNumberingValue {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  MeasureNumberingValue(this._value);

}