/// Calendar dates are represented yyyy-mm-dd format, following ISO 8601. This is a
/// W3C XML Schema date type, but without the optional timezone data.
class YyyyMmDd {
  DateTime _value;

  DateTime get value => _value;

  set value(DateTime value) {
    // add any necessary validation here
    _value = value;
  }

  YyyyMmDd(this._value);

}