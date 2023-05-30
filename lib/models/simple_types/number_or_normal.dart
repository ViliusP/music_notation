/// The number-or-normal values can be either a decimal number or the string
/// "normal". This is used by the line-height and letter-spacing attributes.
class NumberOrNormal {
   _value;

   get value => _value;

  set value( value) {
    // add any necessary validation here
    _value = value;
  }

  NumberOrNormal(this._value);

}