/// The start-stop type is used for an attribute of musical elements that can either
/// start or stop, such as tuplets.

The values of start and stop refer to how an
/// element appears in musical score order, not in MusicXML document order. An
/// element with a stop attribute may precede the corresponding element with a start
/// attribute within a MusicXML document. This is particularly common in multi-staff
/// music. For example, the stopping point for a tuplet may appear in staff 1 before
/// the starting point for the tuplet appears in staff 2 later in the
/// document.

When multiple elements with the same tag are used within the same
/// note, their order within the MusicXML document should match the musical score
/// order.
class StartStop {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  StartStop(this._value);

}