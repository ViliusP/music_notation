/// The wood-value type represents pictograms for wood percussion instruments. The
/// maraca and maracas values distinguish the one- and two-maraca versions of the
/// pictogram.
class WoodValue {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  WoodValue(this._value);

}