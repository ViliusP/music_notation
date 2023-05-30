class YyyyMmDd {
  Datetime _value;

  Datetime get value => _value;

  set value(Datetime value) {
    // add any necessary validation here
    _value = value;
  }

  YyyyMmDd(Datetime value) {
    this.value = value;
  }

}