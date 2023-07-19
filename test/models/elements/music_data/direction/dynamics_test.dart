import 'package:flutter_test/flutter_test.dart';
import 'package:music_notation/src/models/elements/music_data/dynamics.dart';
import 'package:music_notation/src/models/elements/text/text.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:xml/xml.dart';

void main() {
  group("Dynamics parsing", () {
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/f-element/
    test("<f>", () {
      String input = """
        <dynamics default-y="-67">
          <f/>
        </dynamics>
      """;

      var dynamics = Dynamics.fromXml(XmlDocument.parse(input).rootElement);

      expect(dynamics.values.length, 1);
      expect(dynamics.values[0], isA<CommonDynamics>());
      expect(dynamics.values[0], CommonDynamics.f);

      expect(dynamics.printStyle.position.defaultY, -67);
    });
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/ff-element/
    test("<ff>", () {
      String input = """
        <dynamics default-y="-67">
          <ff/>
        </dynamics>
      """;

      var dynamics = Dynamics.fromXml(XmlDocument.parse(input).rootElement);

      expect(dynamics.values.length, 1);
      expect(dynamics.values[0], isA<CommonDynamics>());
      expect(dynamics.values[0], CommonDynamics.ff);

      expect(dynamics.printStyle.position.defaultY, -67);
    });

    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/ffff-element/
    test("<ffff>", () {
      String input = """
        <dynamics default-y="-67">
          <ffff/>
        </dynamics>
      """;

      var dynamics = Dynamics.fromXml(XmlDocument.parse(input).rootElement);

      expect(dynamics.values.length, 1);
      expect(dynamics.values[0], isA<CommonDynamics>());
      expect(dynamics.values[0], CommonDynamics.ffff);

      expect(dynamics.printStyle.position.defaultY, -67);
    });
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/pf-element/
    test("<pf>", () {
      String input = """
        <dynamics default-y="-67" halign="center">
          <pf/>
        </dynamics>
      """;

      var dynamics = Dynamics.fromXml(XmlDocument.parse(input).rootElement);

      expect(dynamics.values.length, 1);
      expect(dynamics.values[0], isA<CommonDynamics>());
      expect(dynamics.values[0], CommonDynamics.pf);

      expect(dynamics.printStyle.position.defaultY, -67);
      expect(
        dynamics.printStyle.horizontalAlignment,
        HorizontalAlignment.center,
      );
    });
    test("<pf>", () {
      String input = """
        <dynamics default-y="35" halign="left" relative-x="-13">
          <f/>
        </dynamics>
      """;

      var dynamics = Dynamics.fromXml(XmlDocument.parse(input).rootElement);

      expect(dynamics.values.length, 1);
      expect(dynamics.values[0], isA<CommonDynamics>());
      expect(dynamics.values[0], CommonDynamics.f);

      expect(dynamics.printStyle.position.defaultY, 35);
      expect(dynamics.printStyle.position.relativeX, -13);

      expect(
        dynamics.printStyle.horizontalAlignment,
        HorizontalAlignment.left,
      );
    });
  });
  group("Parsing dynamics should throw exception", () {
    test("on wrong sequence", () {
      String input = """
        <dynamics default-y="35" halign="left" relative-x="-13">
          <f/>
          <foo/>
        </dynamics>
      """;

      expect(
        () => Dynamics.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlSequenceException>()),
      );
    });
  });
}
