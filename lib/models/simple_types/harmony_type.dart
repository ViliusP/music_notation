/// The harmony-type type differentiates different types of harmonies when alternate
/// harmonies are possible. Explicit harmonies have all note present in the music;
/// implied have some notes missing but implied; alternate represents alternate
/// analyses.
class HarmonyType {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  HarmonyType(this._value);

}