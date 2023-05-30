/// The start-note type describes the starting note of trills and mordents for
/// playback, relative to the current note.
class StartNote {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  StartNote(this._value);

}