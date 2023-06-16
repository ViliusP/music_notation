import 'package:music_notation/src/models/elements/listening.dart';
import 'package:xml/xml.dart';

/// The listen and listening types, new in Version 4.0, specify different ways that a score following or machine listening application can interact with a performer.
///
/// The listen type handles interactions that are specific to a note.
///
/// If multiple child elements of the same type are present, they should have distinct player and/or time-only attributes.
class Listen {
  List<ListenAction> actions;

  Listen({
    required this.actions,
  });

  factory Listen.fromXml(XmlElement xmlElement) {
    return Listen(
      actions: [],
    );
  }
}

/// The abstract class is a stand-in for the different possible types (assess, wait, and other-listen) that the xs:choice can represent.
abstract class ListenAction {
  String name;

  String player;

  String timeOnly;

  ListenAction({
    required this.player,
    required this.timeOnly,
    required this.name,
  });
}

/// By default, an assessment application should assess all notes without a cue child element, and not assess any note with a cue child element.
///
/// The assess type allows this default assessment to be overridden for individual notes.
/// The optional player and time-only attributes restrict the type to apply to a single player or set of times through a repeated section, respectively.
///
/// If missing, the type applies to all players or all times through the repeated section, respectively.
///
/// The player attribute references the id attribute of a player element defined within the matching score-part.
class Assess extends ListenAction {
  String? type;

  Assess({
    required super.player,
    required super.timeOnly,
  }) : super(name: 'assess');
}

/// The wait type specifies a point where the accompaniment should wait for a performer event before continuing.
///
/// This typically happens at the start of new sections or after a held note or indeterminate music.
///
/// These waiting points cannot always be inferred reliably from the contents of the displayed score.
///
/// The optional player and time-only attributes restrict the type to apply to a single player or set of times through a repeated section, respectively.
class Wait extends ListenAction {
  Wait({
    required super.player,
    required super.timeOnly,
  }) : super(name: 'wait');
}

class OtherListening extends ListenAction implements ListeningInteraction {
  String? type;

  OtherListening({
    required super.player,
    required super.timeOnly,
  }) : super(name: 'other-listening');

  factory OtherListening.fromXml(XmlElement xmlElement) {
    return OtherListening(
      player: "",
      timeOnly: "",
    );
  }
}


// 	<xs:simpleType name="time-only">
// 	<xs:annotation>
// 		<xs:documentation>The time-only type is used to indicate that a particular playback- or listening-related element only applies particular times through a repeated section. The value is a comma-separated list of positive integers arranged in ascending order, indicating which times through the repeated section that the element applies.</xs:documentation>
// 	</xs:annotation>
// 	<xs:restriction base="xs:token">
// 		<xs:pattern value="[1-9][0-9]*(, ?[1-9][0-9]*)*"/>
// 	</xs:restriction>
// </xs:simpleType>

