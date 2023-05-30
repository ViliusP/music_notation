/// The sync-type type specifies the style that a score following application should
/// use to synchronize an accompaniment with a performer. The none type indicates no
/// synchronization to the performer. The tempo type indicates synchronization based
/// on the performer tempo rather than individual events in the score. The event
/// type indicates synchronization by following the performance of individual events
/// in the score rather than the performer tempo. The mostly-tempo and mostly-event
/// types combine these two approaches, with mostly-tempo giving more weight to
/// tempo and mostly-event giving more weight to performed events. The always-event
/// type provides the strictest synchronization by not being forgiving of missing
/// performed events.
class SyncType {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  SyncType(this._value);

}