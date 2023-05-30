/// The two-note-turn type describes the ending notes of trills and mordents for
/// playback, relative to the current note.
class TwoNoteTurn {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  TwoNoteTurn(this._value);

}