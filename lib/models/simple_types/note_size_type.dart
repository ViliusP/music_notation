/// The note-size-type type indicates the type of note being defined by a note-size
/// element. The grace-cue type is used for notes of grace-cue size. The grace type
/// is used for notes of cue size that include a grace element. The cue type is used
/// for all other notes with cue size, whether defined explicitly or implicitly via
/// a cue element. The large type is used for notes of large size.
class NoteSizeType {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  NoteSizeType(this._value);

}