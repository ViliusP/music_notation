import 'package:music_notation/src/models/elements/score/part_group.dart';
import 'package:music_notation/src/models/elements/score/score_part.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:xml/xml.dart';

/// Identifies the different musical parts in this document.
///
/// Each part has an ID that is used later within the musical data.
///
/// Since parts may be encoded separately and combined later,
/// identification elements are present at both the score and score-part levels.
///
/// There must be at least one score-part,
/// combined as desired with part-group elements that indicate braces and brackets.
///
/// Parts are ordered from top to bottom in a score based on the order
/// in which they appear in the part-list.
///
/// For full specification,
/// see: https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/part-list/.
class PartList {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  /// For defintion look at [PartGroup].
  final List<PartGroup> partGroups;

  /// For defintion look at [ScorePart].
  final ScorePart scorePart;

  /// This list can conntain [PartGroup] and/or [ScorePart].
  final List<PartListElement> additionalParts;

  PartList({
    this.partGroups = const [],
    required this.scorePart,
    this.additionalParts = const [],
  });

  factory PartList.fromXml(XmlElement xmlElement) {
    final partGroupsElements = xmlElement.children
        .whereType<XmlElement>()
        .takeWhile((element) => element.name.local == 'part-group')
        .map((e) => PartGroup.fromXml(e));

    final children = xmlElement.children.whereType<XmlElement>().toList();
    final firstScorePartIndex = children.indexWhere(
      (element) => element.name.local == 'score-part',
    );

    if (firstScorePartIndex == -1) {
      throw XmlElementRequired('No "score-part" element found in "part-list"');
    }

    final firstScorePart = children[firstScorePartIndex];
    final remainingElements = children.sublist(firstScorePartIndex + 1);

    final List<PartListElement> additionalParts = [];

    for (var element in remainingElements) {
      switch (element.name.local) {
        case 'score-part':
          additionalParts.add(ScorePart.fromXml(element));
          break;
        case 'part-group':
          additionalParts.add(PartGroup.fromXml(element));
          break;
        default:
          throw InvalidXmlElementException(
            message: 'Wrong child in "part-list" element',
            xmlElement: xmlElement,
          );
      }
    }

    return PartList(
      partGroups: partGroupsElements.toList(),
      scorePart: ScorePart.fromXml(firstScorePart),
      additionalParts: additionalParts,
    );
  }

  // TODO: test
  XmlElement toXml() {
    final children = <XmlElement>[];
    children.addAll(partGroups.map((e) => e.toXml()));
    children.add(scorePart.toXml());
    children.addAll(additionalParts.map((e) {
      if (e is PartGroup) {
        return e.toXml();
      } else if (e is ScorePart) {
        return e.toXml();
      } else {
        throw ArgumentError('Unsupported type ${e.runtimeType}');
      }
    }));
    return XmlElement(XmlName('part-list'), [], children);
  }
}

/// Abstract class for additional [PartList] elements.
abstract class PartListElement {}
