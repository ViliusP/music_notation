class PositiveIntegerOrEmpty {
   _value;

   get value => _value;

  set value( value) {
    // add any necessary validation here
    _value = value;
  }

  PositiveIntegerOrEmpty( value) {
    this.value = value;
  }

}