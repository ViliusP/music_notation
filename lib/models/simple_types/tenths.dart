class Tenths {
  double _value;

  double get value => _value;

  set value(double value) {
    // add any necessary validation here
    _value = value;
  }

  Tenths(double value) {
    this.value = value;
  }

}