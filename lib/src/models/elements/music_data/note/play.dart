import 'package:xml/xml.dart';

/// The play type specifies playback techniques to be used in conjunction with the instrument-sound element.
///
/// When used as part of a sound element, it applies to all notes going forward in score order.
///
/// In multi-instrument parts, the affected instrument should be specified using the id attribute.
///
/// When used as part of a note element, it applies to the current note only.
class Play {
  String? id;

  List<PlayContent> content;

  Play({
    this.id,
    this.content = const [],
  });

  factory Play.fromXml(XmlElement? xmlElement) {
    return Play();
  }
}

abstract class PlayContent {
  String? get name;
}

/// The ipa element represents International Phonetic Alphabet (IPA) sounds for vocal music.
///
/// String content is limited to IPA 2015 symbols represented in Unicode 13.0.
class Ipa extends PlayContent {
  @override
  String? get name => "ipa";
}

/// The mute type represents muting for different instruments, including brass, winds, and strings.
///
/// The on and off values are used for undifferentiated mutes. The remaining values represent specific mutes.
enum Mute implements PlayContent {
  on,
  off,
  straight,
  cup,
  harmonNoStem,
  harmonStem,
  bucket,
  plunger,
  har,
  solotone,
  practive,
  stopMute,
  stopHand,
  echo,
  palm;

  @override
  String get name => "mute";
}

/// The semi-pitched type represents categories of indefinite pitch for percussion instruments.
enum SemiPitched implements PlayContent {
  high,
  mediumHigh,
  medium,
  mediumLow,
  low,
  veryLow;

  @override
  String get name => "semi-pitched";
}

/// The other-play element represents other types of playback. The required type attribute indicates the type of playback to which the element content applies.
class OtherPlay implements PlayContent {
  String value;

  String type;

  OtherPlay({
    required this.value,
    required this.type,
  });

  @override
  String get name => "other-play";
}
