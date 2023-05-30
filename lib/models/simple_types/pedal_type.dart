/// The pedal-type simple type is used to distinguish types of pedal directions. The
/// start value indicates the start of a damper pedal, while the sostenuto value
/// indicates the start of a sostenuto pedal. The other values can be used with
/// either the damper or sostenuto pedal. The soft pedal is not included here
/// because there is no special symbol or graphic used for it beyond what can be
/// specified with words and bracket elements.

The change, continue, discontinue,
/// and resume types are used when the line attribute is yes. The change type
/// indicates a pedal lift and retake indicated with an inverted V marking. The
/// continue type allows more precise formatting across system breaks and for more
/// complex pedaling lines. The discontinue type indicates the end of a pedal line
/// that does not include the explicit lift represented by the stop type. The resume
/// type indicates the start of a pedal line that does not include the downstroke
/// represented by the start type. It can be used when a line resumes after being
/// discontinued, or to start a pedal line that is preceded by a text or symbol
/// representation of the pedal.
class PedalType {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  PedalType(this._value);

}