/// The time-relation type indicates the symbol used to represent the
/// interchangeable aspect of dual time signatures.
class TimeRelation {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  TimeRelation(this._value);

}