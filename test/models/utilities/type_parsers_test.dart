import 'package:music_notation/src/models/utilities/type_parsers.dart';
import 'package:test/test.dart';

void main() {
  group('MusicXMLAnyURI', () {
    test('should return true for valid MusicXML anyURI', () {
      expect(MusicXMLAnyURI.isValid('http://www.example.com'), isTrue);
      expect(MusicXMLAnyURI.isValid('https://www.example.com'), isTrue);
      expect(MusicXMLAnyURI.isValid('ftp://example.com'), isTrue);
      expect(MusicXMLAnyURI.isValid('mailto:test@example.com'), isTrue);
      expect(MusicXMLAnyURI.isValid('p1.musicxml'), isTrue);
    });

    test('should return false for invalid MusicXML anyURI', () {
      expect(MusicXMLAnyURI.isValid('hello world'), isFalse);
      expect(MusicXMLAnyURI.isValid('12345'), isFalse);
      expect(MusicXMLAnyURI.isValid('example.com'), isFalse);
      expect(MusicXMLAnyURI.isValid('www.example.com'), isFalse);
      expect(MusicXMLAnyURI.isValid('://www.example.com'), isFalse);
    });
  });
}
