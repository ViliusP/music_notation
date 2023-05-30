/// The up-down-stop-continue type is used for octave-shift elements, indicating the
/// direction of the shift from their true pitched values because of printing
/// difficulty.
class UpDownStopContinue {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  UpDownStopContinue(this._value);

}