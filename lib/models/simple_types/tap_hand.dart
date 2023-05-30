/// The tap-hand type represents the symbol to use for a tap element. The left and
/// right values refer to the SMuFL guitarLeftHandTapping and guitarRightHandTapping
/// glyphs respectively.
class TapHand {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  TapHand(this._value);

}