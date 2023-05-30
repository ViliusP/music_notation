/// The fermata-shape type represents the shape of the fermata sign. The empty value
/// is equivalent to the normal value.
class FermataShape {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  FermataShape(this._value);

}