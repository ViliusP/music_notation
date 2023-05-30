/// The line-shape type distinguishes between straight and curved lines.
class LineShape {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  LineShape(this._value);

}