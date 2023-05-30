/// The step type represents a step of the diatonic scale, represented using the
/// English letters A through G.
class Step {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  Step(this._value);

}