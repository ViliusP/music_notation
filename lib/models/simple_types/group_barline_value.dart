/// The group-barline-value type indicates if the group should have common barlines.
class GroupBarlineValue {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  GroupBarlineValue(this._value);

}