/// The wedge type is crescendo for the start of a wedge that is closed at the left
/// side, diminuendo for the start of a wedge that is closed on the right side, and
/// stop for the end of a wedge. The continue type is used for formatting wedges
/// over a system break, or for other situations where a single wedge is divided
/// into multiple segments.
class WedgeType {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  WedgeType(this._value);

}