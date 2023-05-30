/// The show-tuplet type indicates whether to show a part of a tuplet relating to
/// the tuplet-actual element, both the tuplet-actual and tuplet-normal elements, or
/// neither.
class ShowTuplet {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  ShowTuplet(this._value);

}