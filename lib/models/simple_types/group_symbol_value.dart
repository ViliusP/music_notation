/// The group-symbol-value type indicates how the symbol for a group or multi-staff
/// part is indicated in the score.
class GroupSymbolValue {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  GroupSymbolValue(this._value);

}