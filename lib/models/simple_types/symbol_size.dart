/// The symbol-size type is used to distinguish between full, cue sized, grace cue
/// sized, and oversized symbols.
class SymbolSize {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  SymbolSize(this._value);

}