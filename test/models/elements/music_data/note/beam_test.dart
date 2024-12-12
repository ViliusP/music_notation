import 'package:flutter_test/flutter_test.dart';
import 'package:music_notation/src/models/elements/music_data/note/beam.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:xml/xml.dart';

void main() {
  group('Beam parsing: ', () {
    test("begin type beam should be parsed correctly", () {
      String input = """
        <beam number="1">begin</beam>
      """;

      var beam = Beam.fromXml(XmlDocument.parse(input).rootElement);

      expect(beam.value, BeamValue.begin);
      expect(beam.color?.value, isNull);
      expect(beam.id, isNull);
      expect(beam.fan, isNull);
      expect(beam.repeater, isNull);
      expect(beam.number, 1);
    });
    test("continue type beam should be parsed correctly", () {
      String input = """
        <beam number="1">continue</beam>
      """;

      var beam = Beam.fromXml(XmlDocument.parse(input).rootElement);

      expect(beam.value, BeamValue.bContinue);
      expect(beam.color?.value, isNull);
      expect(beam.id, isNull);
      expect(beam.fan, isNull);
      expect(beam.repeater, isNull);
      expect(beam.number, 1);
    });

    test("end type beam should be parsed correctly", () {
      String input = """
        <beam number="1">end</beam>
      """;

      var beam = Beam.fromXml(XmlDocument.parse(input).rootElement);

      expect(beam.value, BeamValue.end);
      expect(beam.color?.value, isNull);
      expect(beam.id, isNull);
      expect(beam.fan, isNull);
      expect(beam.repeater, isNull);
      expect(beam.number, 1);
    });
    test("should throw on beam value", () {
      String input = """
        <beam number="1">foo</beam>
      """;

      expect(
        () => Beam.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlTypeException>()),
      );
    });
  });
}
