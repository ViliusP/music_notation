/// The arrow-style type represents the style of an arrow, using Unicode arrow
/// terminology. Filled and hollow arrows indicate polygonal single arrows. Paired
/// arrows are duplicate single arrows in the same direction. Combined arrows apply
/// to double direction arrows like left right, indicating that an arrow in one
/// direction should be combined with an arrow in the other direction.
class ArrowStyle {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  ArrowStyle(this._value);

}