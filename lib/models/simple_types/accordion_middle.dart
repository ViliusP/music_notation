class AccordionMiddle {
  int _value;

  int get value => _value;

  set value(int value) {
    // add any necessary validation here
    _value = value;
  }

  AccordionMiddle(int value) {
    this.value = value;
  }

}