/// The start-stop-discontinue type is used to specify ending types. Typically, the
/// start type is associated with the left barline of the first measure in an
/// ending. The stop and discontinue types are associated with the right barline of
/// the last measure in an ending. Stop is used when the ending mark concludes with
/// a downward jog, as is typical for first endings. Discontinue is used when there
/// is no downward jog, as is typical for second endings that do not conclude a
/// piece.
class StartStopDiscontinue {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  StartStopDiscontinue(this._value);

}