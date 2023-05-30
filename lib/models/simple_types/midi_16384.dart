class Midi16384 {
  int _value;

  int get value => _value;

  set value(int value) {
    // add any necessary validation here
    _value = value;
  }

  Midi16384(int value) {
    this.value = value;
  }

}