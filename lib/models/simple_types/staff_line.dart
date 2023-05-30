/// The staff-line type indicates the line on a given staff. Staff lines are
/// numbered from bottom to top, with 1 being the bottom line on a staff.
class StaffLine {
  int _value;

  int get value => _value;

  set value(int value) {
    // add any necessary validation here
    _value = value;
  }

  StaffLine(this._value);

}