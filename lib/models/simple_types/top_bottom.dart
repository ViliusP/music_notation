/// The top-bottom type is used to indicate the top or bottom part of a vertical
/// shape like non-arpeggiate.
class TopBottom {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  TopBottom(this._value);

}