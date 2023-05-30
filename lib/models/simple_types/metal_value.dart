/// The metal-value type represents pictograms for metal percussion instruments. The
/// hi-hat value refers to a pictogram like Stone's high-hat cymbals but without the
/// long vertical line at the bottom.
class MetalValue {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  MetalValue(this._value);

}