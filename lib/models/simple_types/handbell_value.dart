class HandbellValue {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  HandbellValue(String value) {
    this.value = value;
  }

}