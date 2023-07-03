import 'package:flutter_test/flutter_test.dart';
import 'package:music_notation/src/models/data_types/symbol_size.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:xml/xml.dart';

void main() {
  group('Symbol size', () {
    test("should parse grace size", () {
      String input = '''
          <foo size="grace-cue"></foo>
        ''';

      var symbolSize = SymbolSize.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(symbolSize, SymbolSize.graceCue);
    });
    test("should throw on empty size attribute", () {
      String input = '''
          <foo size=""></foo>
        ''';

      expect(
        () => SymbolSize.fromXml(
          XmlDocument.parse(input).rootElement,
        ),
        throwsA(isA<MusicXmlTypeException>()),
      );
    });
    test("should throw on invalid size attribute value", () {
      String input = '''
          <foo size="bar"></foo>
        ''';

      expect(
        () => SymbolSize.fromXml(
          XmlDocument.parse(input).rootElement,
        ),
        throwsA(isA<MusicXmlTypeException>()),
      );
    });
  });
}
