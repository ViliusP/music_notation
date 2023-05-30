class NumberOrNormal {
   _value;

   get value => _value;

  set value( value) {
    // add any necessary validation here
    _value = value;
  }

  NumberOrNormal( value) {
    this.value = value;
  }

}