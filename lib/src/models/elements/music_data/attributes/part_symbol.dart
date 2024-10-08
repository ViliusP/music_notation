import 'package:music_notation/src/models/data_types/group_symbol_value.dart';
import 'package:music_notation/src/models/printing.dart';
import 'package:music_notation/src/models/elements/text/text.dart';
import 'package:xml/xml.dart';

/// The part-symbol type indicates how a symbol for a multi-staff part is indicated in the score;
/// brace is the default value.
///
/// The top-staff and bottom-staff attributes are used when the brace does not extend across the entire part.
/// For example, in a 3-staff organ part, the top-staff will typically be 1 for the right hand,
/// while the bottom-staff will typically be 2 for the left hand.
///
/// Staff 3 for the pedals is usually outside the brace.
/// By default, the presence of a part-symbol element that does not extend across the entire part
///  also indicates a corresponding change in the common barlines within a part.
class PartSymbol {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  GroupSymbolValue value;

  int? topStaff;

  int? bottomStaff;

  Position position;

  Color color;

  PartSymbol({
    this.value = GroupSymbolValue.brace,
    this.topStaff,
    this.bottomStaff,
    this.position = const Position.empty(),
    this.color = const Color.empty(),
  });

  factory PartSymbol.fromXml(XmlElement partSymbolElement) {
    return PartSymbol();
  }
}
