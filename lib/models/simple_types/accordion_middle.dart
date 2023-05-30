/// The accordion-middle type may have values of 1, 2, or 3, corresponding to having
/// 1 to 3 dots in the middle section of the accordion registration symbol. This
/// type is not used if no dots are present.
class AccordionMiddle {
  int _value;

  int get value => _value;

  set value(int value) {
    // add any necessary validation here
    _value = value;
  }

  AccordionMiddle(this._value);

}