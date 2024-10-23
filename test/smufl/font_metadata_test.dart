import 'package:music_notation/src/smufl/font_metadata.dart';
import 'package:test/test.dart';

void main() {
  group('EngravingDefaults', () {
    test('fromJson constructs a valid object', () {
      final json = {
        'textFontFamily': ['Academico', 'Century Schoolbook', 'serif'],
        'arrowShaftThickness': 0.16,
        'barlineSeparation': 0.6,
        'beamSpacing': 0.33,
        'beamThickness': 0.5,
      };

      final engravingDefaults = EngravingDefaults.fromJson(json);

      expect(
        engravingDefaults.textFontFamily,
        ['Academico', 'Century Schoolbook', 'serif'],
      );
      expect(engravingDefaults.arrowShaftThickness, 0.16);
      expect(engravingDefaults.barlineSeparation, 0.6);
      expect(engravingDefaults.beamSpacing, 0.33);
      expect(engravingDefaults.beamThickness, 0.5);
    });

    test('fromJson no textFontFamily', () {
      final json = {
        'tupletBracketThickness': 1.01,
      };

      final engravingDefaults = EngravingDefaults.fromJson(json);

      expect(engravingDefaults.textFontFamily, []);
      expect(engravingDefaults.tupletBracketThickness, 1.01);
    });

    test('fromJson constructs a valid object with Bravura defaults', () {
      final json = {
        "arrowShaftThickness": 0.16,
        "barlineSeparation": 0.4,
        "beamSpacing": 0.25,
        "beamThickness": 0.5,
        "bracketThickness": 0.5,
        "dashedBarlineDashLength": 0.5,
        "dashedBarlineGapLength": 0.25,
        "dashedBarlineThickness": 0.16,
        "hBarThickness": 1.0,
        "hairpinThickness": 0.16,
        "legerLineExtension": 0.4,
        "legerLineThickness": 0.16,
        "lyricLineThickness": 0.16,
        "octaveLineThickness": 0.16,
        "pedalLineThickness": 0.16,
        "repeatBarlineDotSeparation": 0.16,
        "repeatEndingLineThickness": 0.16,
        "slurEndpointThickness": 0.1,
        "slurMidpointThickness": 0.22,
        "staffLineThickness": 0.13,
        "stemThickness": 0.12,
        "subBracketThickness": 0.16,
        "textEnclosureThickness": 0.16,
        "textFontFamily": ["Academico", "Century Schoolbook", "Edwin", "serif"],
        "thickBarlineThickness": 0.5,
        "thinBarlineThickness": 0.16,
        "tieEndpointThickness": 0.1,
        "tieMidpointThickness": 0.22,
        "tupletBracketThickness": 0.16
      };

      final engravingDefaults = EngravingDefaults.fromJson(json);

      expect(engravingDefaults.arrowShaftThickness, 0.16);
      expect(engravingDefaults.barlineSeparation, 0.4);
      expect(engravingDefaults.beamSpacing, 0.25);
      expect(engravingDefaults.beamThickness, 0.5);
      expect(engravingDefaults.bracketThickness, 0.5);
      expect(engravingDefaults.dashedBarlineDashLength, 0.5);
      expect(engravingDefaults.dashedBarlineGapLength, 0.25);
      expect(engravingDefaults.dashedBarlineThickness, 0.16);
      expect(engravingDefaults.hBarThickness, 1.0);
      expect(engravingDefaults.hairpinThickness, 0.16);
      expect(engravingDefaults.ledgerLineExtension, 0.4);
      expect(engravingDefaults.ledgerLineThickness, 0.16);
      expect(engravingDefaults.lyricLineThickness, 0.16);
      expect(engravingDefaults.octaveLineThickness, 0.16);
      expect(engravingDefaults.pedalLineThickness, 0.16);
      expect(engravingDefaults.repeatBarlineDotSeparation, 0.16);
      expect(engravingDefaults.repeatEndingLineThickness, 0.16);
      expect(engravingDefaults.slurEndpointThickness, 0.1);
      expect(engravingDefaults.slurMidpointThickness, 0.22);
      expect(engravingDefaults.staffLineThickness, 0.13);
      expect(engravingDefaults.stemThickness, 0.12);
      expect(engravingDefaults.subBracketThickness, 0.16);
      expect(engravingDefaults.textEnclosureThickness, 0.16);
      expect(engravingDefaults.textFontFamily,
          ["Academico", "Century Schoolbook", "Edwin", "serif"]);
      expect(engravingDefaults.thickBarlineThickness, 0.5);
      expect(engravingDefaults.thinBarlineThickness, 0.16);
      expect(engravingDefaults.tieEndpointThickness, 0.1);
      expect(engravingDefaults.tieMidpointThickness, 0.22);
      expect(engravingDefaults.tupletBracketThickness, 0.16);
    });
  });

  group('GlyphBBox', () {
    test('fromJson constructs a valid object', () {
      final json = {
        'bBoxNE': [1.0, 1.5],
        'bBoxSW': [0.0, -1.0],
      };

      final bbox = GlyphBBox.fromJson(json);

      expect(bbox.bBoxNE, [1.0, 1.5]);
      expect(bbox.bBoxSW, [0.0, -1.0]);
    });
  });

  group('GlyphAnchor', () {
    test('fromJson constructs a valid object', () {
      final json = {
        'name': 'top',
        'coordinates': [0.0, 1.0],
      };

      final anchor = GlyphAnchor.fromJson(json);

      expect(anchor.name, 'top');
      expect(anchor.coordinates, [0.0, 1.0]);
    });
  });

  group('GlyphWithAnchor', () {
    test('fromJson constructs a valid object', () {
      final json = {
        'noteheadQuarter': {
          'stemDownNW': [0.0, -0.184],
          'stemUpSE': [1.328, 0.184],
        },
      };

      final glyphWithAnchor = GlyphWithAnchor.fromJson(
        'noteheadQuarter',
        json['noteheadQuarter']!,
      );

      expect(glyphWithAnchor.glyphName, 'noteheadQuarter');
      expect(glyphWithAnchor.anchors[AnchorField.stemDownNW], [0.0, -0.184]);
      expect(glyphWithAnchor.anchors[AnchorField.stemUpSE], [1.328, 0.184]);
    });
  });

  group('FontMetadata', () {
    test('fromJson constructs a valid object', () {
      final json = {
        'fontName': 'Sebastian',
        'fontVersion': 1.07,
        'engravingDefaults': {
          'textFontFamily': ['Academico', 'serif'],
          'arrowShaftThickness': 0.16,
          'barlineSeparation': 0.6,
        },
        'glyphBBoxes': {
          'noteheadQuarter': {
            'bBoxNE': [1.0, 1.5],
            'bBoxSW': [0.0, -1.0]
          }
        },
        'glyphsWithAnchors': {
          'noteheadQuarter': {
            'stemDownNW': [0.0, -0.184],
            'stemUpSE': [1.328, 0.184]
          }
        }
      };

      final fontMetadata = FontMetadata.fromJson(json);

      expect(fontMetadata.fontName, 'Sebastian');
      expect(fontMetadata.fontVersion, 1.07);
      expect(
        fontMetadata.engravingDefaults.textFontFamily,
        ['Academico', 'serif'],
      );
      expect(fontMetadata.glyphBBoxes['noteheadQuarter']!.bBoxNE, [1.0, 1.5]);
      expect(fontMetadata.glyphsWithAnchors.length, 1);
      expect(fontMetadata.glyphsWithAnchors[0].glyphName, 'noteheadQuarter');
      expect(
        fontMetadata.glyphsWithAnchors[0].anchors[AnchorField.stemDownNW],
        [0.0, -0.184],
      );
    });
  });
}
