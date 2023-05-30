/// The tenths type is a number representing tenths of interline staff space
/// (positive or negative). Both integer and decimal values are allowed, such as 5
/// for a half space and 2.5 for a quarter space. Interline space is measured from
/// the middle of a staff line.

Distances in a MusicXML file are measured in
/// tenths of staff space. Tenths are then scaled to millimeters within the scaling
/// element, used in the defaults element at the start of a score. Individual staves
/// can apply a scaling factor to adjust staff size. When a MusicXML element or
/// attribute refers to tenths, it means the global tenths defined by the scaling
/// element, not the local tenths as adjusted by the staff-size element.
class Tenths {
  double _value;

  double get value => _value;

  set value(double value) {
    // add any necessary validation here
    _value = value;
  }

  Tenths(this._value);

}