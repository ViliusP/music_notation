/// The trill-step type describes the alternating note of trills and mordents for
/// playback, relative to the current note.
class TrillStep {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  TrillStep(this._value);

}