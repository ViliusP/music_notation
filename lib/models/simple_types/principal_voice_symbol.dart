/// The principal-voice-symbol type represents the type of symbol used to indicate a
/// principal or secondary voice. The "plain" value represents a plain square
/// bracket. The value of "none" is used for analysis markup when the
/// principal-voice element does not have a corresponding appearance in the score.
class PrincipalVoiceSymbol {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  PrincipalVoiceSymbol(this._value);

}