import 'package:flutter_test/flutter_test.dart';
import 'package:music_notation/src/models/data_types/placement.dart';
import 'package:music_notation/src/models/elements/music_data/direction/direction.dart';
import 'package:music_notation/src/models/elements/music_data/direction/wedge.dart';
import 'package:xml/xml.dart';

void main() {
  group("Directions from 'Tutorial: Après un rêve'", () {
    test("#1", () {
      String input = """
        <direction directive="yes" placement="above">
          <direction-type>
            <words default-y="15" font-size="10.5" font-weight="bold">Andantino</words>
          </direction-type>
          <sound tempo="60"/>
        </direction>
      """;

      var direction = Direction.fromXml(XmlDocument.parse(input).rootElement);

      expect(direction.types.length, 1);
      expect(direction.types[0], isA<DirectionWords>());
      expect(direction.offset, isNull);
      expect(direction.editorialVoice.footnote, isNull);
      expect(direction.editorialVoice.level, isNull);
      expect(direction.editorialVoice.voice, isNull);
      expect(direction.staff, isNull);
      expect(direction.sound, isNotNull);
      expect(direction.listening, isNull);

      expect(direction.directive, true);
      expect(direction.id, isNull);
      expect(direction.placement, Placement.above);
      expect(direction.system, isNull);
    });
    test("#2", () {
      String input = """
        <direction placement="above">
          <direction-type>
            <words default-x="15" default-y="15" font-size="9" font-style="italic">dolce</words>
          </direction-type>
        </direction>
      """;

      var direction = Direction.fromXml(XmlDocument.parse(input).rootElement);

      expect(direction.types.length, 1);
      expect(direction.types[0], isA<DirectionWords>());
      expect(direction.offset, isNull);
      expect(direction.editorialVoice.footnote, isNull);
      expect(direction.editorialVoice.level, isNull);
      expect(direction.editorialVoice.voice, isNull);
      expect(direction.staff, isNull);
      expect(direction.sound, isNull);
      expect(direction.listening, isNull);
      // -- Attributes
      expect(direction.directive, isNull);
      expect(direction.id, isNull);
      expect(direction.placement, Placement.above);
      expect(direction.system, isNull);
    });
    test("#3", () {
      String input = """
        <direction placement="above">
          <direction-type>
            <wedge default-y="20" type="crescendo"/>
          </direction-type>
          <offset>-8</offset>
        </direction>
      """;

      var direction = Direction.fromXml(XmlDocument.parse(input).rootElement);

      expect(direction.types.length, 1);
      expect(direction.types[0], isA<Wedge>());
      expect(direction.offset, isNotNull);
      expect(direction.editorialVoice.footnote, isNull);
      expect(direction.editorialVoice.level, isNull);
      expect(direction.editorialVoice.voice, isNull);
      expect(direction.staff, isNull);
      expect(direction.sound, isNull);
      expect(direction.listening, isNull);
      // -- Attributes
      expect(direction.directive, isNull);
      expect(direction.id, isNull);
      expect(direction.placement, Placement.above);
      expect(direction.system, isNull);
    });
    test("#4", () {
      String input = """
        <direction>
          <direction-type>
            <wedge spread="11" type="stop"/>
          </direction-type>
          <offset>-11</offset>
        </direction>
      """;

      var direction = Direction.fromXml(XmlDocument.parse(input).rootElement);

      expect(direction.types.length, 1);
      expect(direction.types[0], isA<Wedge>());
      expect(direction.offset, isNotNull);
      expect(direction.editorialVoice.footnote, isNull);
      expect(direction.editorialVoice.level, isNull);
      expect(direction.editorialVoice.voice, isNull);
      expect(direction.staff, isNull);
      expect(direction.sound, isNull);
      expect(direction.listening, isNull);
      // -- Attributes
      expect(direction.directive, isNull);
      expect(direction.id, isNull);
      expect(direction.placement, isNull);
      expect(direction.system, isNull);
    });
    test("#5", () {
      String input = """
        <direction placement="above">
          <direction-type>
            <wedge default-y="20" spread="11" type="diminuendo"/>
          </direction-type>
          <offset>3</offset>
        </direction>
      """;

      var direction = Direction.fromXml(XmlDocument.parse(input).rootElement);

      expect(direction.types.length, 1);
      expect(direction.types[0], isA<Wedge>());
      expect(direction.offset, isNotNull);
      expect(direction.editorialVoice.footnote, isNull);
      expect(direction.editorialVoice.level, isNull);
      expect(direction.editorialVoice.voice, isNull);
      expect(direction.staff, isNull);
      expect(direction.sound, isNull);
      expect(direction.listening, isNull);
      // -- Attributes
      expect(direction.directive, isNull);
      expect(direction.id, isNull);
      expect(direction.placement, Placement.above);
      expect(direction.system, isNull);
    });
    test("#6", () {
      String input = """
        <direction>
            <direction-type>
              <wedge type="stop"/>
            </direction-type>
          <offset>2</offset>
        </direction>
      """;

      var direction = Direction.fromXml(XmlDocument.parse(input).rootElement);

      expect(direction.types.length, 1);
      expect(direction.types[0], isA<Wedge>());
      expect(direction.offset, isNotNull);
      expect(direction.editorialVoice.footnote, isNull);
      expect(direction.editorialVoice.level, isNull);
      expect(direction.editorialVoice.voice, isNull);
      expect(direction.staff, isNull);
      expect(direction.sound, isNull);
      expect(direction.listening, isNull);
      // -- Attributes
      expect(direction.directive, isNull);
      expect(direction.id, isNull);
      expect(direction.placement, isNull);
      expect(direction.system, isNull);
    });
    test("#7", () {
      String input = """
        <direction placement="below">
          <direction-type>
            <dynamics default-x="129" default-y="-75" halign="left">
              <pp/>
            </dynamics>
          </direction-type>
          <staff>1</staff>
          <sound dynamics="40"/>
        </direction>
      """;

      var direction = Direction.fromXml(XmlDocument.parse(input).rootElement);

      expect(direction.types.length, 1);
      expect(direction.types[0], isA<DirectionDynamics>());
      expect(direction.offset, isNull);
      expect(direction.editorialVoice.footnote, isNull);
      expect(direction.editorialVoice.level, isNull);
      expect(direction.editorialVoice.voice, isNull);
      expect(direction.staff, 1);
      expect(direction.sound, isNotNull);
      expect(direction.listening, isNull);
      // -- Attributes
      expect(direction.directive, isNull);
      expect(direction.id, isNull);
      expect(direction.placement, Placement.below);
      expect(direction.system, isNull);
    });
  });
}
