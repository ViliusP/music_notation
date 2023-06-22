import 'package:music_notation/src/models/elements/score/credit.dart';
import 'package:music_notation/src/models/elements/text/text.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:music_notation/src/models/printing.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

void main() {
  group('Image credit', () {
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/credit-image-element/
    test('should parse modified <credit-image> example correctly', () {
      String input = '''
        <credit page="1">
          <credit-type>logo</credit-type>
          <link xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="https://www.w3.org/" xlink:show="new"/>
          <credit-image source="images/mmlogo.png" type="image.png" default-x="572" default-y="96"/>
        </credit>
      ''';

      var rootElement = XmlDocument.parse(input).rootElement;

      var credit = Credit.fromXml(rootElement);

      expect(credit.page, 1);
      expect(credit.creditTypes.length, 1);
      expect(credit.creditTypes[0], "logo");
      expect(credit.links.length, 1);

      expect(credit, isA<ImageCredit>());
      final ImageCredit imageCredit = credit as ImageCredit;

      expect(imageCredit.value.source, "images/mmlogo.png");
      expect(imageCredit.value.type, "image.png");
      expect(imageCredit.value.position.defaultX, 572);
      expect(imageCredit.value.position.defaultY, 96);
    });
    test('should throw on empty credit-type', () {
      String input = '''
        <credit page="1">
          <credit-type></credit-type>
          <credit-image source="images/mmlogo.png" type="image.png" default-x="572" default-y="96"/>
        </credit>
      ''';

      var rootElement = XmlDocument.parse(input).rootElement;

      expect(
        () => Credit.fromXml(rootElement),
        throwsA(isA<InvalidXmlElementException>()),
      );
    });
    test('should throw on invalid credit-type', () {
      String input = '''
        <credit page="1">
          <credit-type><foo>bar</foo></credit-type>
          <credit-image source="images/mmlogo.png" type="image.png" default-x="572" default-y="96"/>
        </credit>
      ''';

      var rootElement = XmlDocument.parse(input).rootElement;

      expect(
        () => Credit.fromXml(rootElement),
        throwsA(isA<InvalidXmlElementException>()),
      );
    });
  });
  group('Text credit', () {
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/concert-score-and-for-part-elements/
    test('should parse <concert-score> and <for-part> example correctly', () {
      String input = '''
        <credit page="1">
            <credit-type>part name</credit-type>
            <credit-words default-x="105" default-y="1353" font-size="12" valign="top">Score in C</credit-words>
        </credit>
      ''';

      var rootElement = XmlDocument.parse(input).rootElement;

      var credit = Credit.fromXml(rootElement);

      expect(credit.page, 1);
      expect(credit, isA<TextCredit>());
      final TextCredit textCredit = credit as TextCredit;

      expect(textCredit.creditTypes.firstOrNull, "part name");
      expect(textCredit.value, isA<CreditWords>());

      final CreditWords creditWords = textCredit.value as CreditWords;
      final Position position = creditWords.formatting.position;

      expect(creditWords.value, "Score in C");
      expect(position.defaultX, 105);
      expect(position.defaultY, 1353);
      expect(creditWords.formatting.font.size?.getValue, 12);
      expect(creditWords.formatting.verticalAlignment, VerticalAlignment.top);
    });
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/credit-symbol-element/
    test('should parse <credit-symbol> example correctly', () {
      String input = '''
        <credit page="1">
          <credit-words default-x="37" default-y="1495" font-size="12" valign="top">Practice with</credit-words>
          <credit-symbol>fClef</credit-symbol>
          <credit-words font-size="12">and</credit-words>
          <credit-symbol>cClef</credit-symbol>
          <credit-words font-size="12">clefs as well.</credit-words>
        </credit>
      ''';

      var rootElement = XmlDocument.parse(input).rootElement;

      var credit = Credit.fromXml(rootElement);

      expect(credit.page, 1);
      expect(credit, isA<TextCredit>());
      final TextCredit textCredit = credit as TextCredit;

      expect(textCredit.value, isA<CreditWords>());

      final CreditWords creditWords = textCredit.value as CreditWords;
      expect(creditWords.value, "Practice with");

      expect(creditWords.formatting.position.defaultX, 37);
      expect(creditWords.formatting.position.defaultY, 1495);
      expect(creditWords.formatting.font.size?.getValue, 12);
      expect(creditWords.formatting.verticalAlignment, VerticalAlignment.top);

      final CreditText innerCredit0 = textCredit.nextCredits[0].creditText;
      final CreditText innerCredit1 = textCredit.nextCredits[1].creditText;
      final CreditText innerCredit2 = textCredit.nextCredits[2].creditText;
      final CreditText innerCredit3 = textCredit.nextCredits[3].creditText;
      expect(innerCredit0, isA<CreditSymbol>());
      expect(innerCredit1, isA<CreditWords>());
      expect(innerCredit2, isA<CreditSymbol>());
      expect(innerCredit3, isA<CreditWords>());

      expect((innerCredit0 as CreditSymbol).value, "fClef");
      expect((innerCredit1 as CreditWords).value, "and");
      expect(innerCredit1.formatting.font.size?.getValue, 12);

      expect((innerCredit2 as CreditSymbol).value, "cClef");
      expect((innerCredit3 as CreditWords).value, "clefs as well.");
      expect(innerCredit3.formatting.font.size?.getValue, 12);
    });

    test('should parse custom credit correctly', () {
      String input = '''
        <credit id="fooID" page="2">
          <link xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="https://www.w3.org/" xlink:show="new"/>
          <bookmark element="barfoo1" name="foobar1" position="3" id="Variation-VI-P1"/>
          <credit-words default-x="2" default-y="1" font-size="24" valign="bottom">Practice without</credit-words>
          <link xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="https://www.w4.org/" xlink:show="new"/>
          <bookmark element="barfoo2" position="2" name="foobar2" id="Variation-VI-P2"/>
          <credit-symbol>fClef</credit-symbol>
          <credit-symbol>cMateo</credit-symbol>
        </credit>
      ''';

      var rootElement = XmlDocument.parse(input).rootElement;

      var credit = Credit.fromXml(rootElement);

      expect(credit.page, 2);
      expect(credit.id, "fooID");
      expect(credit.links.length, 1);
      expect(credit.bookmarks.length, 1);

      expect(credit, isA<TextCredit>());

      final TextCredit textCredit = credit as TextCredit;
      expect(textCredit.value, isA<CreditWords>());

      final CreditWords creditWords = textCredit.value as CreditWords;
      expect(creditWords.value, "Practice without");
      expect(creditWords.formatting.position.defaultX, 2);
      expect(creditWords.formatting.position.defaultY, 1);
      expect(creditWords.formatting.font.size?.getValue, 24);
      expect(
        creditWords.formatting.verticalAlignment,
        VerticalAlignment.bottom,
      );

      final NextCredit nextCredit0 = textCredit.nextCredits[0];
      expect(nextCredit0.creditText, isA<CreditSymbol>());
      expect(nextCredit0.bookmarks.length, 1);
      expect(nextCredit0.links.length, 1);

      final NextCredit nextCredit1 = textCredit.nextCredits[1];
      expect(nextCredit1.creditText, isA<CreditSymbol>());
      expect(nextCredit1.bookmarks.length, 0);
      expect(nextCredit1.links.length, 0);
    });
  });
}
