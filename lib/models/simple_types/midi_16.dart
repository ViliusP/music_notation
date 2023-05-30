class Midi16 {
  int _value;

  int get value => _value;

  set value(int value) {
    // add any necessary validation here
    _value = value;
  }

  Midi16(int value) {
    this.value = value;
  }

}