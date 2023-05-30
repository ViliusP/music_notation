/// The yes-no-number type is used for attributes that can be either boolean or
/// numeric values.
class YesNoNumber {
   _value;

   get value => _value;

  set value( value) {
    // add any necessary validation here
    _value = value;
  }

  YesNoNumber(this._value);

}