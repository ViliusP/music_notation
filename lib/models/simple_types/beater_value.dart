/// The beater-value type represents pictograms for beaters, mallets, and sticks
/// that do not have different materials represented in the pictogram. The finger
/// and hammer values are in addition to Stone's list.
class BeaterValue {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  BeaterValue(this._value);

}