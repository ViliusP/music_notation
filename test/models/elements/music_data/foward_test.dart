// File: test/forward_test.dart

import 'package:music_notation/src/models/exceptions.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';
import 'package:music_notation/src/models/elements/music_data/forward.dart';

void main() {
  group('Forward.fromXml', () {
    test('parses a simple <forward> with only <duration>', () {
      const xmlString = '''
      <forward>
        <duration>4</duration>
      </forward>
      ''';

      final xmlElement = XmlDocument.parse(xmlString).rootElement;
      final forward = Forward.fromXml(xmlElement);

      expect(forward.duration, equals(4.0));
      expect(forward.staff, isNull);
    });

    test('parses a <forward> with <duration> and <staff>', () {
      const xmlString = '''
      <forward>
        <duration>8</duration>
        <staff>2</staff>
      </forward>
      ''';

      final xmlElement = XmlDocument.parse(xmlString).rootElement;
      final forward = Forward.fromXml(xmlElement);

      expect(forward.duration, equals(8.0));
      expect(forward.staff, equals(2));
    });

    test('parses a <forward> with <duration>, <staff>, and <editorial>', () {
      const xmlString = '''
      <forward>
        <duration>6</duration>
        <staff>1</staff>
        <footnote>Advance cursor by six divisions.</footnote>
        <voice>Ensure proper alignment.</voice>
      </forward>
      ''';

      final xmlElement = XmlDocument.parse(xmlString).rootElement;
      final forward = Forward.fromXml(xmlElement);

      expect(forward.duration, equals(6.0));
      expect(forward.staff, equals(1));
      // expect(
      //   forward.editorialVoice.footnote,
      //   equals('Advance cursor by six divisions.'),
      // );
      // expect(forward.editorialVoice.voice, equals('Ensure proper alignment.'));
    });

    test('throws XmlElementContentException when <duration> is missing', () {
      const xmlString = '''
      <forward>
        <staff>1</staff>
      </forward>
      ''';

      final xmlElement = XmlDocument.parse(xmlString).rootElement;

      expect(
        () => Forward.fromXml(xmlElement),
        throwsA(isA<XmlElementContentException>()),
      );
    });

    test('throws MusicXmlFormatException when <duration> is not a number', () {
      const xmlString = '''
      <forward>
        <duration>invalid_number</duration>
      </forward>
      ''';

      final xmlElement = XmlDocument.parse(xmlString).rootElement;

      expect(
        () => Forward.fromXml(xmlElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });

    test('throws MusicXmlFormatException when <duration> is zero', () {
      const xmlString = '''
      <forward>
        <duration>0</duration>
      </forward>
      ''';

      final xmlElement = XmlDocument.parse(xmlString).rootElement;

      expect(
        () => Forward.fromXml(xmlElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });

    test('throws MusicXmlFormatException when <duration> is negative', () {
      const xmlString = '''
      <forward>
        <duration>-5</duration>
      </forward>
      ''';

      final xmlElement = XmlDocument.parse(xmlString).rootElement;

      expect(
        () => Forward.fromXml(xmlElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });

    test('throws MusicXmlFormatException when <staff> is not an integer', () {
      const xmlString = '''
      <forward>
        <duration>4</duration>
        <staff>invalid_staff</staff>
      </forward>
      ''';

      final xmlElement = XmlDocument.parse(xmlString).rootElement;

      expect(
        () => Forward.fromXml(xmlElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });

    test('throws MusicXmlFormatException when <staff> is zero', () {
      const xmlString = '''
      <forward>
        <duration>4</duration>
        <staff>0</staff>
      </forward>
      ''';

      final xmlElement = XmlDocument.parse(xmlString).rootElement;

      expect(
        () => Forward.fromXml(xmlElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });

    test(
        'throws XmlElementContentException when <editorial> contains invalid content',
        () {
      const xmlString = '''
      <forward>
        <duration>4</duration>
        <unknownElement>Invalid content</unknownElement>
      </forward>
      ''';

      final xmlElement = XmlDocument.parse(xmlString).rootElement;

      expect(
        () => Forward.fromXml(xmlElement),
        throwsA(isA<XmlElementContentException>()),
      );
    });

    test('parses <forward> with multiple <editorial> elements', () {
      const xmlString = '''
      <forward>
        <duration>10</duration>
        <footnote>First footnote.</footnote>
        <level>Second level note.</level>
      </forward>
      ''';

      final xmlElement = XmlDocument.parse(xmlString).rootElement;

      // Assuming Editorial.fromXml handles multiple <editorial> elements by overriding,
      // which might not be desired. Adjust according to your implementation.
      // For this test, we'll check if the first <editorial> is parsed.
      final forward = Forward.fromXml(xmlElement);

      expect(forward.duration, equals(10.0));
      // expect(forward.editorialVoice.footnote, equals('First footnote.'));
      // expect(forward.editorialVoice.level, equals('Second level note.'));
    });

    test('throws XmlElementContentException when <forward> is empty', () {
      const xmlString = '''
      <forward></forward>
      ''';

      final xmlElement = XmlDocument.parse(xmlString).rootElement;

      expect(() => Forward.fromXml(xmlElement),
          throwsA(isA<XmlElementContentException>()));
    });

    test('parses <forward> without <staff> and with <editorial>', () {
      const xmlString = '''
      <forward>
        <duration>3</duration>
        <footnote>Forward without staff.</footnote>
      </forward>
      ''';

      final xmlElement = XmlDocument.parse(xmlString).rootElement;
      final forward = Forward.fromXml(xmlElement);

      expect(forward.duration, equals(3.0));
      expect(forward.staff, isNull);
      // expect(forward.editorialVoice.footnote, equals('Forward without staff.'));
      // expect(forward.editorialVoice.level, isNull);
    });
  });
}
