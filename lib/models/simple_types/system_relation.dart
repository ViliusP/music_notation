/// The system-relation type distinguishes elements that are associated with a
/// system rather than the particular part where the element appears. A value of
/// only-top indicates that the element should appear only on the top part of the
/// current system. A value of also-top indicates that the element should appear on
/// both the current part and the top part of the current system. If this value
/// appears in a score, when parts are created the element should only appear once
/// in this part, not twice. A value of none indicates that the element is
/// associated only with the current part, not with the system.
class SystemRelation {
}