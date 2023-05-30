class YesNoNumber {
   _value;

   get value => _value;

  set value( value) {
    // add any necessary validation here
    _value = value;
  }

  YesNoNumber( value) {
    this.value = value;
  }

}