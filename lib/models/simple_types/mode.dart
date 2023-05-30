/// The mode type is used to specify major/minor and other mode distinctions. Valid
/// mode values include major, minor, dorian, phrygian, lydian, mixolydian, aeolian,
/// ionian, locrian, and none.
class Mode {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  Mode(this._value);

}