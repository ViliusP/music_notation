import 'package:music_notation/models/printing.dart';

/// The staff-divide element represents the staff division arrow symbols found
/// at SMuFL code points U+E00B, U+E00C, and U+E00D.
class StaffDivide {
  StaffDivideSymbol type;

  PrintStyleAlign printStyleAlign;

  String? id;

  StaffDivide({
    required this.type,
    required this.printStyleAlign,
    this.id,
  });
}

enum StaffDivideSymbol {
  down,
  up,
  upDown;
}
