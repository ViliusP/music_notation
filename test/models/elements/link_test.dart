import 'package:music_notation/src/models/elements/link.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

void main() {
  group('Link', () {
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/link-element/
    test('should parse from <link> example correctly', () {
      String input = '''
        <link xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="https://www.w3.org/" xlink:show="new"/>
      ''';

      var link = Link.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(link.attributes.href, "https://www.w3.org/");
      expect(link.attributes.show, XLinkShow.new_);
    });
    test('should parse fully filled <link> correctly', () {
      String input = '''
        <link xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="https://www.foo.bar/" xlink:role="http://www.example.com/linkprops/studentlist" xlink:type="simple" default-x="1" default-y="1" relative-x="2" relative-y="2" xlink:actuate="other" xlink:show="embed" name="bar" element="foo" position="5"/>
      ''';

      var link = Link.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(link.attributes.href, "https://www.foo.bar/");
      expect(link.attributes.show, XLinkShow.embed);
      expect(link.attributes.actuate, XLinkActuate.other);
      expect(
        link.attributes.role,
        "http://www.example.com/linkprops/studentlist",
      );
      expect(link.attributes.type, "simple");
      expect(link.elementPosition, 5);
      expect(link.element, "foo");
      expect(link.name, "bar");
      expect(link.position.defaultX, 1);
      expect(link.position.defaultY, 1);
      expect(link.position.relativeX, 2);
      expect(link.position.relativeX, 2);
    });
    test('should throw on negative position', () {
      String input = '''
        <link xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="https://www.foo.bar/" position="-1"/>
      ''';

      expect(
        () => Link.fromXml(
          XmlDocument.parse(input).rootElement,
        ),
        throwsA(isA<InvalidMusicXmlType>()),
      );
    });
    test('should throw on empty position', () {
      String input = '''
        <link xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="https://www.foo.bar/" position=""/>
      ''';

      expect(
        () => Link.fromXml(
          XmlDocument.parse(input).rootElement,
        ),
        throwsA(isA<InvalidMusicXmlType>()),
      );
    });
    test('should throw on invalid position', () {
      String input = '''
        <link xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="https://www.foo.bar/" position="foo"/>
      ''';

      expect(
        () => Link.fromXml(
          XmlDocument.parse(input).rootElement,
        ),
        throwsA(isA<InvalidMusicXmlType>()),
      );
    });
  });
  group('Group link', () {
    test('should throw on wrong show', () {
      String input = '''
        <foo xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="https://www.foo.bar/" xlink:show="foo" />
      ''';

      expect(
        () => LinkAttributes.fromXml(
          XmlDocument.parse(input).rootElement,
        ),
        throwsA(isA<InvalidMusicXmlType>()),
      );
    });
    test('should throw on wrong actuate', () {
      String input = '''
        <foo xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="https://www.foo.bar/" xlink:actuate="foo" />
      ''';

      expect(
        () => LinkAttributes.fromXml(
          XmlDocument.parse(input).rootElement,
        ),
        throwsA(isA<InvalidMusicXmlType>()),
      );
    });
    test('should have show property XLinkShow.replace on default', () {
      String input = '''
        <foo xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="https://www.foo.bar/" />
      ''';

      LinkAttributes attributes = LinkAttributes.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(
        attributes.show,
        XLinkShow.replace,
      );
    });

    test('should have show actuate XLinkActuate.onRequest on default', () {
      String input = '''
        <foo xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="https://www.foo.bar/" />
      ''';

      LinkAttributes attributes = LinkAttributes.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(
        attributes.actuate,
        XLinkActuate.onRequest,
      );
    });
  });
}
