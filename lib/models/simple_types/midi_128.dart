class Midi128 {
  int _value;

  int get value => _value;

  set value(int value) {
    // add any necessary validation here
    _value = value;
  }

  Midi128(int value) {
    this.value = value;
  }

}