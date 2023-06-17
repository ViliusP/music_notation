/// The start-stop type is used for an attribute of musical elements that can either start or stop, such as tuplets.
///
/// The values of start and stop refer to how an element appears in musical score order, not in MusicXML document order.
/// An element with a stop attribute may precede the corresponding element with a start attribute within a MusicXML document.
/// This is particularly common in multi-staff music.
/// For example, the stopping point for a tuplet may appear in staff 1 before the starting point for the tuplet appears in staff 2 later in the document.
///
/// When multiple elements with the same tag are used within the same note, their order within the MusicXML document should match the musical score order.
enum StartStop {
  start,
  stop;

  static fromString(String value) {
    throw UnimplementedError();
  }
}

/// The start-stop-continue type is used for an attribute of musical elements that can either start or stop,
/// but also need to refer to an intermediate point in the symbol,
/// as for complex slurs or for formatting of symbols across system breaks.
///
/// The values of start, stop, and continue refer to how an element appears in musical score order,
/// not in MusicXML document order.
/// An element with a stop attribute may precede the corresponding element with a start attribute within a MusicXML document.
/// This is particularly common in multi-staff music.
/// For example, the stopping point for a slur may appear in staff 1 before the starting point for the slur appears in staff 2 later in the document.
///
/// When multiple elements with the same tag are used within the same note,
/// their order within the MusicXML document should match the musical score order.
/// For example, a note that marks both the end of one slur and the start of a new slur
/// should have the incoming slur element with a type of stop precede the outgoing slur element with a type of start.
enum StartStopContinue {
  /// Starting point of an element.
  start,

  /// Stopping point of an element.
  stop,

  /// Continuation of an element, including system breaks.
  ///
  /// "continue".
  tContinue;
}

/// The start-stop-single type is used for an attribute of musical elements
/// that can be used for either multi-note or single-note musical elements, as for groupings.
///
/// When multiple elements with the same tag are used within the same note,
/// their order within the MusicXML document should match the musical score order.
enum StartStopSingle {
  start,
  stop,
  single;
}

enum UpDownStopContinue {
  up,
  down,
  stop,
  tContinue;
}