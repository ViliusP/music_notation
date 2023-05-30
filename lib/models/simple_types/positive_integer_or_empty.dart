/// The positive-integer-or-empty values can be either a positive integer or an
/// empty string.
class PositiveIntegerOrEmpty {
   _value;

   get value => _value;

  set value( value) {
    // add any necessary validation here
    _value = value;
  }

  PositiveIntegerOrEmpty(this._value);

}