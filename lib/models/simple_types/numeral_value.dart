class NumeralValue {
  int _value;

  int get value => _value;

  set value(int value) {
    // add any necessary validation here
    _value = value;
  }

  NumeralValue(int value) {
    this.value = value;
  }

}