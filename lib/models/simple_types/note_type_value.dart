/// The note-type-value type is used for the MusicXML type element and represents
/// the graphic note type, from 1024th (shortest) to maxima (longest).
class NoteTypeValue {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  NoteTypeValue(this._value);

}