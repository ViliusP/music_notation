/// The divisions type is used to express values in terms of the musical divisions
/// defined by the divisions element. It is preferred that these be integer values
/// both for MIDI interoperability and to avoid roundoff errors.
class Divisions {
  double _value;

  double get value => _value;

  set value(double value) {
    // add any necessary validation here
    _value = value;
  }

  Divisions(this._value);

}