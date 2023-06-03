import 'package:music_notation/models/text.dart';

/// The footnote element specifies editorial information that appears in footnotes in the printed score.
///
/// It is defined within a group due to its multiple uses within the MusicXML schema.
class Footnote {
  FormattedText value;
  Footnote({
    required this.value,
  });
}
