import 'package:music_notation/models/data_types/start_stop.dart';
import 'package:music_notation/models/elements/music_data/direction/direction.dart';
import 'package:music_notation/models/printing.dart';

class PrincipalVoice implements DirectionType {
  String value;

  StartStop type;

  /// Indicates the type of symbol used.
  ///
  /// When used for analysis separate from any printed score markings,
  /// it should be set to none.
  ///
  /// Otherwise if the type is stop it should be set to plain.
  ///
  /// Also see [PrincipalVoiceSymbol].
  PrincipalVoiceSymbol symbol;

  PrintStyleAlign printStyleAlign;

  String? id;

  PrincipalVoice({
    required this.value,
    required this.type,
    required this.printStyleAlign,
    required this.id,
    required this.symbol,
  });
}

/// The principal-voice-symbol type represents the type of symbol used to
/// indicate a principal or secondary voice.
///
/// The "plain" value represents a plain square bracket.
///
/// The value of "none" is used for analysis markup when
/// the principal-voice element does not have a corresponding appearance in the score.
///
/// Also see: [principal-voice-symbol data type | MusicXML 4.0](https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/principal-voice-symbol/)
enum PrincipalVoiceSymbol {
  hauptstimme,
  nebenstimme,
  plain,

  /// Used for analysis markup when the principal-voice element does not have a corresponding appearance in the score.
  none;
}
