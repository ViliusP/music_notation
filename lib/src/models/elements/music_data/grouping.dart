import 'package:music_notation/src/models/data_types/start_stop.dart';
import 'package:xml/xml.dart';

/// he grouping type is used for musical analysis.
/// When the type attribute is "start" or "single",
/// it usually contains one or more feature elements.
/// The number attribute is used for distinguishing between overlapping and hierarchical groupings.
/// The member-of attribute allows for easy distinguishing of
/// what grouping elements are in what hierarchy.
/// Feature elements contained within a "stop" type of grouping may be ignored.
///
/// This element is flexible to allow for different types of analyses.
/// Future versions of the MusicXML format may add elements that can represent
/// more standardized categories of analysis data, allowing for easier data sharing.
class Grouping {
  List<Feature> features;

  StartStopSingle type;

  String? id;

  String? memberOf;

  String number;

  Grouping({
    this.features = const [],
    required this.type,
    this.id,
    this.memberOf,
    this.number = "1",
  });

  factory Grouping.fromXml(XmlElement xmlElement) {
    return Grouping(
      type: StartStopSingle.start,
    );
  }
}

/// The feature type is a part of the grouping element used for musical analysis.
///
/// The type attribute represents the type of the feature and the element content represents its value.
///
/// This type is flexible to allow for different analyses.
class Feature {
  String value;

  String? type;

  Feature({
    required this.value,
    this.type,
  });
}
