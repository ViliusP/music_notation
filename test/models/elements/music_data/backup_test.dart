// File: test/backup_test.dart

import 'package:music_notation/src/models/exceptions.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';
import 'package:music_notation/src/models/elements/music_data/backup.dart';

void main() {
  group('Backup.fromXml', () {
    test('parses a simple <backup> with only <duration>', () {
      const xmlString = '''
      <backup>
        <duration>4</duration>
      </backup>
      ''';

      final xmlElement = XmlDocument.parse(xmlString).rootElement;
      final backup = Backup.fromXml(xmlElement);

      expect(backup.duration, equals(4.0));
    });

    test('throws FormatException when <duration> is missing', () {
      const xmlString = '''
      <backup>
        <editorial>
          <footnote>Missing duration.</footnote>
        </editorial>
      </backup>
      ''';

      final xmlElement = XmlDocument.parse(xmlString).rootElement;

      expect(() => Backup.fromXml(xmlElement), throwsFormatException);
    });

    test('throws FormatException when <duration> is not a number', () {
      const xmlString = '''
      <backup>
        <duration>invalid_number</duration>
      </backup>
      ''';

      final xmlElement = XmlDocument.parse(xmlString).rootElement;

      expect(
        () => Backup.fromXml(xmlElement),
        throwsA(isA<MusicXmlTypeException>()),
      );
    });

    test('throws FormatException when <duration> is zero', () {
      const xmlString = '''
      <backup>
        <duration>0</duration>
      </backup>
      ''';

      final xmlElement = XmlDocument.parse(xmlString).rootElement;

      expect(
        () => Backup.fromXml(xmlElement),
        throwsA(isA<MusicXmlTypeException>()),
      );
    });

    test('throws FormatException when <duration> is negative', () {
      const xmlString = '''
      <backup>
        <duration>-5</duration>
      </backup>
      ''';

      final xmlElement = XmlDocument.parse(xmlString).rootElement;

      expect(
        () => Backup.fromXml(xmlElement),
        throwsA(isA<MusicXmlTypeException>()),
      );
    });

    test('parses <backup> with multiple <editorial> elements', () {
      const xmlString = '''
      <backup>
        <duration>6</duration>
        <footnote>First footnote.</footnote>
        <level>Second editorial note.</level>
      </backup>
      ''';

      final xmlElement = XmlDocument.parse(xmlString).rootElement;
      final backup = Backup.fromXml(xmlElement);

      expect(backup.duration, equals(6.0));
      expect(backup.editorial, isNotNull);
    });
  });
}
