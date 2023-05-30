/// The staff-line-position type indicates the line position on a given staff. Staff
/// lines are numbered from bottom to top, with 1 being the bottom line on a staff.
/// A staff-line-position value can extend beyond the range of the lines on the
/// current staff.
class StaffLinePosition {
  int _value;

  int get value => _value;

  set value(int value) {
    // add any necessary validation here
    _value = value;
  }

  StaffLinePosition(this._value);

}