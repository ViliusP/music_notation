import 'package:music_notation/src/models/elements/bookmark.dart';
import 'package:music_notation/src/models/elements/link.dart';
import 'package:music_notation/src/models/elements/listening.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/attributes.dart';
import 'package:music_notation/src/models/elements/music_data/backup.dart';
import 'package:music_notation/src/models/elements/music_data/barline.dart';
import 'package:music_notation/src/models/elements/music_data/direction/direction.dart';
import 'package:music_notation/src/models/elements/music_data/figured_bass.dart';
import 'package:music_notation/src/models/elements/music_data/forward.dart';
import 'package:music_notation/src/models/elements/music_data/harmony/harmony.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/models/elements/music_data/print.dart';
import 'package:music_notation/src/models/elements/music_data/sound/sound.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:xml/xml.dart';

abstract class MusicDataElement {
  factory MusicDataElement.fromXml(XmlElement xmlElement) {
    switch (xmlElement.name.local) {
      case 'note':
        return Note.fromXml(xmlElement);
      case 'backup':
        return Backup.fromXml(xmlElement);
      case 'forward':
        return Forward.fromXml(xmlElement);
      case 'direction':
        return Direction.fromXml(xmlElement);
      case 'attributes':
        return Attributes.fromXml(xmlElement);
      case 'harmony':
        return Harmony.fromXml(xmlElement);
      case 'figured-bass':
        return FiguredBass.fromXml(xmlElement);
      case 'print':
        return Print.fromXml(xmlElement);
      case 'sound':
        return Sound.fromXml(xmlElement);
      case 'listening':
        return Listening.fromXml(xmlElement);
      case 'barline':
        return Barline.fromXml(xmlElement);
      case 'grouping':
        return Barline.fromXml(xmlElement);
      case 'link':
        return Link.fromXml(xmlElement);
      case 'bookmark':
        return Bookmark.fromXml(xmlElement);
      default:
        throw XmlElementContentException(
          message: 'Unknown MusicDataElement: ${xmlElement.name.local}',
          xmlElement: xmlElement,
        );
    }
  }

  XmlElement toXml();
}
