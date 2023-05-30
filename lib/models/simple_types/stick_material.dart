/// The stick-material type represents the material being displayed in a stick
/// pictogram.
class StickMaterial {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  StickMaterial(this._value);

}