/// The stick-type type represents the shape of pictograms where the material in the
/// stick, mallet, or beater is represented in the pictogram.
class StickType {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  StickType(this._value);

}