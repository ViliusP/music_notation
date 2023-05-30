/// The staff-divide-symbol type is used for staff division symbols. The down, up,
/// and up-down values correspond to SMuFL code points U+E00B, U+E00C, and U+E00D
/// respectively.
class StaffDivideSymbol {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  StaffDivideSymbol(this._value);

}