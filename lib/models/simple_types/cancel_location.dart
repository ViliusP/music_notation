/// The cancel-location type is used to indicate where a key signature cancellation
/// appears relative to a new key signature: to the left, to the right, or before
/// the barline and to the left. It is left by default. For mid-measure key
/// elements, a cancel-location of before-barline should be treated like a
/// cancel-location of left.
class CancelLocation {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  CancelLocation(this._value);

}