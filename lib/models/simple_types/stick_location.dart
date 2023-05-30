/// The stick-location type represents pictograms for the location of sticks,
/// beaters, or mallets on cymbals, gongs, drums, and other instruments.
class StickLocation {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  StickLocation(this._value);

}