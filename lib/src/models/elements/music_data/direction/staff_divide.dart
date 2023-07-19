import 'package:music_notation/src/models/elements/music_data/direction/direction.dart';
import 'package:music_notation/src/models/printing.dart';
import 'package:xml/xml.dart';

/// The staff-divide element represents the staff division arrow symbols found
/// at SMuFL code points U+E00B, U+E00C, and U+E00D.
class StaffDivide implements DirectionType {
  StaffDivideSymbol type;

  PrintStyleAlign printStyleAlign;

  String? id;

  StaffDivide({
    required this.type,
    required this.printStyleAlign,
    this.id,
  });

  factory StaffDivide.fromXml(XmlElement xmlElement) {
    throw UnimplementedError();
  }
}

enum StaffDivideSymbol {
  down,
  up,
  upDown;
}
