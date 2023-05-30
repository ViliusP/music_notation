/// The tremolo-type is used to distinguish double-note, single-note, and unmeasured
/// tremolos.
class TremoloType {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  TremoloType(this._value);

}