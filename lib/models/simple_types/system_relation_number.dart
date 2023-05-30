/// The system-relation-number type distinguishes measure numbers that are
/// associated with a system rather than the particular part where the element
/// appears. A value of only-top or only-bottom indicates that the number should
/// appear only on the top or bottom part of the current system, respectively. A
/// value of also-top or also-bottom indicates that the number should appear on both
/// the current part and the top or bottom part of the current system, respectively.
/// If these values appear in a score, when parts are created the number should only
/// appear once in this part, not twice. A value of none indicates that the number
/// is associated only with the current part, not with the system.
class SystemRelationNumber {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  SystemRelationNumber(this._value);

}