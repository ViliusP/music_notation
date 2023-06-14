import 'package:music_notation/models/elements/music_data/attributes/attributes.dart';
import 'package:music_notation/models/elements/music_data/attributes/clef.dart';
import 'package:music_notation/models/elements/music_data/attributes/transpose.dart';

/// The for-part type is used in a concert score to indicate the transposition
/// for a transposed part created from that score.
///
/// It is only used in score files that contain a concert-score element in the defaults.
///
/// This allows concert scores with transposed parts to be represented in a single uncompressed MusicXML file.
///
/// The optional number attribute refers to staff numbers,
/// from top to bottom on the system.
///
/// If absent, the child elements apply to all staves in the created part.
class ForPart extends Transposition {
  @override
  String get name => "for-part";
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  CleffContent partClef;

  TransposeContent partTranspose;

  ForPart({
    required this.partClef,
    required this.partTranspose,
  });
}
