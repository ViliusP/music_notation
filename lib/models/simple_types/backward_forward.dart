/// The backward-forward type is used to specify repeat directions. The start of the
/// repeat has a forward direction while the end of the repeat has a backward
/// direction.
class BackwardForward {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  BackwardForward(this._value);

}