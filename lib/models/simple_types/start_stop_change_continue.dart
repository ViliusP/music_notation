/// The start-stop-change-continue type is used to distinguish types of pedal
/// directions.
class StartStopChangeContinue {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  StartStopChangeContinue(this._value);

}