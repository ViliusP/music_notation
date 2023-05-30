/// The MusicXML format supports six levels of beaming, up to 1024th notes. Unlike
/// the number-level type, the beam-level type identifies concurrent beams in a beam
/// group. It does not distinguish overlapping beams such as grace notes within
/// regular notes, or beams used in different voices.
class BeamLevel {
  int _value;

  int get value => _value;

  set value(int value) {
    // add any necessary validation here
    _value = value;
  }

  BeamLevel(this._value);

}