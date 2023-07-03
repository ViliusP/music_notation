import 'package:music_notation/src/models/utilities/type_parsers.dart';
import 'package:test/test.dart';

void main() {
  group('MusicXMLAnyURI', () {
    test('should return true for valid MusicXML anyURI', () {
      const validURIs = [
        'http://www.example.com',
        'https://www.example.com',
        'ftp://example.com',
        'mailto:test@example.com',
        'p1.musicxml',
        'opus/winterreise.musicxml',
      ];

      for (final uri in validURIs) {
        expect(MusicXMLAnyURI.isValid(uri), isTrue, reason: 'Failed on $uri');
      }
    });

    test('should return false for invalid MusicXML anyURI', () {
      const invalidURIs = [
        'hello world',
        '12345',
        'example.com',
        'www.example.com',
        '://www.example.com',
        'mailto:test@example',
      ];

      for (final uri in invalidURIs) {
        expect(MusicXMLAnyURI.isValid(uri), isFalse, reason: 'Failed on $uri');
      }
    });
  });
}
