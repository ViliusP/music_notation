import 'package:flutter_test/flutter_test.dart';
import 'package:music_notation/src/models/data_types/line.dart';
import 'package:music_notation/src/models/elements/music_data/direction/wedge.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:xml/xml.dart';

void main() {
  group("Wedge", () {
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/forward-element/
    group("should be parsed from '<forward>' example", () {
      test("#1", () {
        String input = """
          <wedge default-y="-73" spread="0" type="crescendo"/>
        """;

        var wedge = Wedge.fromXml(XmlDocument.parse(input).rootElement);

        expect(wedge.type, WedgeType.crescendo);
        expect(wedge.color.value, isNull);
        expect(wedge.dashedFormatting.dashLength, isNull);
        expect(wedge.dashedFormatting.spaceLength, isNull);
        expect(wedge.position.defaultX, isNull);
        expect(wedge.position.defaultY, -73);
        expect(wedge.position.relativeX, isNull);
        expect(wedge.position.relativeY, isNull);
        expect(wedge.id, isNull);
        expect(wedge.lineType, LineType.solid);
        expect(wedge.niente, false);
        expect(wedge.number, isNull);
        expect(wedge.spread, 0);
      });
      test("#2", () {
        String input = """
          <wedge spread="12" type="stop"/>
        """;

        var wedge = Wedge.fromXml(XmlDocument.parse(input).rootElement);

        expect(wedge.type, WedgeType.stop);
        expect(wedge.color.value, isNull);
        expect(wedge.dashedFormatting.dashLength, isNull);
        expect(wedge.dashedFormatting.spaceLength, isNull);
        expect(wedge.position.defaultX, isNull);
        expect(wedge.position.defaultY, isNull);
        expect(wedge.position.relativeX, isNull);
        expect(wedge.position.relativeY, isNull);
        expect(wedge.id, isNull);
        expect(wedge.lineType, LineType.solid);
        expect(wedge.niente, false);
        expect(wedge.number, isNull);
        expect(wedge.spread, 12);
      });
    });
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/n-element/
    group("should be parsed from '<n>' example", () {
      test("#1", () {
        String input = """
          <wedge default-y="-60" spread="15" type="diminuendo"/>
        """;

        var wedge = Wedge.fromXml(XmlDocument.parse(input).rootElement);

        expect(wedge.type, WedgeType.diminuendo);
        expect(wedge.color.value, isNull);
        expect(wedge.dashedFormatting.dashLength, isNull);
        expect(wedge.dashedFormatting.spaceLength, isNull);
        expect(wedge.position.defaultX, isNull);
        expect(wedge.position.defaultY, -60);
        expect(wedge.position.relativeX, isNull);
        expect(wedge.position.relativeY, isNull);
        expect(wedge.id, isNull);
        expect(wedge.lineType, LineType.solid);
        expect(wedge.niente, false);
        expect(wedge.number, isNull);
        expect(wedge.spread, 15);
      });
      test("#2", () {
        String input = """
          <wedge type="stop"/>
        """;

        var wedge = Wedge.fromXml(XmlDocument.parse(input).rootElement);

        expect(wedge.type, WedgeType.stop);
        expect(wedge.color.value, isNull);
        expect(wedge.dashedFormatting.dashLength, isNull);
        expect(wedge.dashedFormatting.spaceLength, isNull);
        expect(wedge.position.defaultX, isNull);
        expect(wedge.position.defaultY, isNull);
        expect(wedge.position.relativeX, isNull);
        expect(wedge.position.relativeY, isNull);
        expect(wedge.id, isNull);
        expect(wedge.lineType, LineType.solid);
        expect(wedge.niente, false);
        expect(wedge.number, isNull);
        expect(wedge.spread, isNull);
      });
    });
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/tutorial-apres-un-reve/
    group("should be parsed from 'Tutorial: Après un rêve' example", () {
      test("#1", () {
        String input = """
          <wedge default-y="20" type="crescendo"/>
        """;
        var wedge = Wedge.fromXml(XmlDocument.parse(input).rootElement);

        expect(wedge.type, WedgeType.crescendo);
        expect(wedge.color.value, isNull);
        expect(wedge.dashedFormatting.dashLength, isNull);
        expect(wedge.dashedFormatting.spaceLength, isNull);
        expect(wedge.position.defaultX, isNull);
        expect(wedge.position.defaultY, 20);
        expect(wedge.position.relativeX, isNull);
        expect(wedge.position.relativeY, isNull);
        expect(wedge.id, isNull);
        expect(wedge.lineType, LineType.solid);
        expect(wedge.niente, false);
        expect(wedge.number, isNull);
        expect(wedge.spread, isNull);
      });
      test("#2", () {
        String input = """
          <wedge spread="11" type="stop"/>
        """;

        var wedge = Wedge.fromXml(XmlDocument.parse(input).rootElement);

        expect(wedge.type, WedgeType.stop);
        expect(wedge.color.value, isNull);
        expect(wedge.dashedFormatting.dashLength, isNull);
        expect(wedge.dashedFormatting.spaceLength, isNull);
        expect(wedge.position.defaultX, isNull);
        expect(wedge.position.defaultY, isNull);
        expect(wedge.position.relativeX, isNull);
        expect(wedge.position.relativeY, isNull);
        expect(wedge.id, isNull);
        expect(wedge.lineType, LineType.solid);
        expect(wedge.niente, false);
        expect(wedge.number, isNull);
        expect(wedge.spread, 11);
      });
      test("#3", () {
        String input = """
          <wedge default-y="20" spread="11" type="diminuendo"/>
        """;

        var wedge = Wedge.fromXml(XmlDocument.parse(input).rootElement);

        expect(wedge.type, WedgeType.diminuendo);
        expect(wedge.color.value, isNull);
        expect(wedge.dashedFormatting.dashLength, isNull);
        expect(wedge.dashedFormatting.spaceLength, isNull);
        expect(wedge.position.defaultX, isNull);
        expect(wedge.position.defaultY, 20);
        expect(wedge.position.relativeX, isNull);
        expect(wedge.position.relativeY, isNull);
        expect(wedge.id, isNull);
        expect(wedge.lineType, LineType.solid);
        expect(wedge.niente, false);
        expect(wedge.number, isNull);
        expect(wedge.spread, 11);
      });
    });

    group("parsing", () {
      test("should throw on invalid content", () {
        String input = """
        <wedge default-y="20" spread="11" type="diminuendo">
          <foo></foo>
        </wedge>
      """;

        expect(
          () => Wedge.fromXml(XmlDocument.parse(input).rootElement),
          throwsA(isA<XmlElementContentException>()),
        );
      });
      test("should be thrown on text content", () {
        String input = """
        <wedge default-y="20" spread="11" type="diminuendo">
          foo
        </wedge>
      """;

        expect(
          () => Wedge.fromXml(XmlDocument.parse(input).rootElement),
          throwsA(isA<XmlElementContentException>()),
        );
      });
    });
  });
}
