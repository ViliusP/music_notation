/// The staff-number type indicates staff numbers within a multi-staff part. Staves
/// are numbered from top to bottom, with 1 being the top staff on a part.
class StaffNumber {
  int _value;

  int get value => _value;

  set value(int value) {
    // add any necessary validation here
    _value = value;
  }

  StaffNumber(this._value);

}