/// The start-stop-single type is used for an attribute of musical elements that can
/// be used for either multi-note or single-note musical elements, as for
/// groupings.

When multiple elements with the same tag are used within the same
/// note, their order within the MusicXML document should match the musical score
/// order.
class StartStopSingle {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  StartStopSingle(this._value);

}