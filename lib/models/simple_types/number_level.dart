class NumberLevel {
  int _value;

  int get value => _value;

  set value(int value) {
    // add any necessary validation here
    _value = value;
  }

  NumberLevel(int value) {
    this.value = value;
  }

}