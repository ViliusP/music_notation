/// The pitched-value type represents pictograms for pitched percussion instruments.
/// The chimes and tubular chimes values distinguish the single-line and double-line
/// versions of the pictogram.
class PitchedValue {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  PitchedValue(this._value);

}