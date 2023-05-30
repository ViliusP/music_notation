/// The glass-value type represents pictograms for glass percussion instruments.
class GlassValue {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  GlassValue(this._value);

}