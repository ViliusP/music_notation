class PitchedValue {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  PitchedValue(String value) {
    this.value = value;
  }

}