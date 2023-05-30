/// The beam-value type represents the type of beam associated with each of 8 beam
/// levels (up to 1024th notes) available for each note.
class BeamValue {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  BeamValue(this._value);

}