/// The effect-value type represents pictograms for sound effect percussion
/// instruments. The cannon, lotus flute, and megaphone values are in addition to
/// Stone's list.
class EffectValue {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  EffectValue(this._value);

}