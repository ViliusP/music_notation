/// The font-size can be one of the CSS font sizes (xx-small, x-small, small,
/// medium, large, x-large, xx-large) or a numeric point size.
class FontSize {
   _value;

   get value => _value;

  set value( value) {
    // add any necessary validation here
    _value = value;
  }

  FontSize(this._value);

}