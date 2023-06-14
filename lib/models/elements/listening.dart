import 'package:music_notation/models/elements/music_data/note/listen.dart';
import 'package:music_notation/models/elements/offset.dart';
import 'package:xml/xml.dart';

/// The listen and listening types, new in Version 4.0,
/// specify different ways that a score following or machine listening application can interact with a performer.
/// The listening type handles interactions that change the state of the listening application from the specified point in the performance onward.
/// If multiple child elements of the same type are present,
/// they should have distinct player and/or time-only attributes.
///
/// The offset element is used to indicate that the listening change takes place offset from the current score position.
/// If the listening element is a child of a direction element,
/// the listening offset element overrides the direction offset element if both elements are present.
/// Note that the offset reflects the intended musical position for the change in state.
/// It should not be used to compensate for latency issues in particular hardware configurations.
class Listening {
  Offset? offset;
}

/// The sync type specifies the style that a score following application
/// should use the synchronize an accompaniment with a performer.
/// If this type is not included in a score,
/// default synchronization depends on the application.
///
/// The optional latency attribute specifies a time in milliseconds
/// that the listening application should expect from the performer.
/// The optional player and time-only attributes restrict the element to apply to a single player
/// or set of times through a repeated section, respectively.
class Sync extends ListeningInteraction {
  /// Specifies the style that a score following application should use to
  /// synchronize an accompaniment with a performer.
  SyncType type;

  ///Specifies a latency time in milliseconds that the listening application should expect from the performer.
  int? latency;

  /// Restricts the element to apply to a single <player>.
  String? player;

  /// Restricts the element to apply to a set of times through a repeated section.
  String? timeOnly;

  Sync({
    required this.type,
    this.latency,
    this.player,
    this.timeOnly,
  });

  factory Sync.fromXml(XmlElement xmlElement) {
    return Sync(
      type: SyncType.none,
    );
  }
}

/// The sync-type type specifies the style that a score following application
/// should use to synchronize an accompaniment with a performer.
/// The none type indicates no synchronization to the performer.
/// The tempo type indicates synchronization based on the performer tempo
/// rather than individual events in the score.
/// The event type indicates synchronization by following the performance of individual events
/// in the score rather than the performer tempo.
/// The mostly-tempo and mostly-event types combine these two approaches,
/// with mostly-tempo giving more weight to tempo and
/// mostly-event giving more weight to performed events.
/// The always-event type provides the strictest synchronization
/// by not being forgiving of missing performed events.
enum SyncType {
  none,
  tempo,
  mostlyTempo,
  mostlyEvent,
  event,
  alwaysEvent;
}

abstract class ListeningInteraction {
  ListeningInteraction();

  // This base class can include shared properties and methods common
  // to all types of listening interactions if any.

  factory ListeningInteraction.fromXml(XmlElement xmlElement) {
    if (xmlElement.name.local == 'sync') {
      return Sync.fromXml(xmlElement);
    } else if (xmlElement.name.local == 'other-listening') {
      return OtherListening.fromXml(xmlElement);
    } else {
      throw Exception(
        'Unknown ListeningInteraction type: ${xmlElement.name.local}',
      );
    }
  }
}
