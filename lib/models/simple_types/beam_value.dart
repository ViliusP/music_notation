class BeamValue {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  BeamValue(String value) {
    this.value = value;
  }

}