class RotationDegrees {
  double _value;

  double get value => _value;

  set value(double value) {
    // add any necessary validation here
    _value = value;
  }

  RotationDegrees(double value) {
    this.value = value;
  }

}