import 'package:music_notation/src/models/data_types/start_stop.dart';
import 'package:music_notation/src/models/elements/music_data/direction/direction.dart';
import 'package:music_notation/src/models/printing.dart';
import 'package:music_notation/src/models/elements/text/text.dart';
import 'package:xml/xml.dart';

/// The dashes type represents dashes, used for instance with cresc. and dim. marks.
class Dashes implements DirectionType {
  StartStopContinue type;

  int? number;

  Position position;

  Color color;

  String? id;

  Dashes({
    required this.type,
    this.number,
    required this.position,
    required this.color,
    this.id,
  });

  factory Dashes.fromXml(XmlElement xmlElement) {
    return Dashes(
      type: StartStopContinue.start,
      position: Position.fromXml(xmlElement),
      color: Color.fromXml(xmlElement),
    );
  }
}
