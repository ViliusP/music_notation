import 'dart:ui';

import 'package:music_notation/src/models/data_types/step.dart';
import 'package:music_notation/src/models/elements/layout.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/key.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/time.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/smufl/glyph_class.dart';

class VisualMusicElement {
  final dynamic equivalent;

  final String _symbol;
  final ElementPosition _position;
  ElementPosition get position => _position;

  final bool influencedByClef;

  /// Offset for element, so it could be painted correctly in G4 note position.
  /// Most of times it only has dy offset and zero value dx.
  final Offset _defaultOffsetG4;
  Offset get defaultOffset => _defaultOffsetG4;

  final HorizontalMargins? defaultMargins;

  String get symbol => _symbol;

  VisualMusicElement({
    required this.equivalent,
    required String symbol,
    required ElementPosition position,
    required this.influencedByClef,
    this.defaultMargins,
    Offset? defaultOffsetG4,
  })  : _symbol = symbol,
        _position = position,
        _defaultOffsetG4 = defaultOffsetG4 ?? const Offset(0, 0);

  static List<VisualMusicElement> fromTimeBeat(TimeBeat timeBeat) {
    if (timeBeat.timeSignatures.length > 1) {
      throw UnimplementedError(
        "multiple beat and beat type in one time-beat are not implemented in renderer yet",
      );
    }
    var signature = timeBeat.timeSignatures.firstOrNull;
    if (signature != null) {
      return [
        VisualMusicElement(
          equivalent: timeBeat,
          symbol: _integerToSmufl(
            int.parse(signature.beats),
          ),
          position: const ElementPosition(
            step: Step.D,
            octave: 5,
          ),
          influencedByClef: false,
          defaultOffsetG4: const Offset(0, -5),
          defaultMargins: HorizontalMargins(left: 0, right: 48),
        ),
        VisualMusicElement(
          equivalent: timeBeat,
          symbol: _integerToSmufl(
            int.parse(signature.beatType),
          ),
          position: const ElementPosition(
            step: Step.G,
            octave: 4,
          ),
          influencedByClef: false,
          defaultOffsetG4: const Offset(0, -5),
          defaultMargins: HorizontalMargins(left: 16, right: 0),
        )
      ];
    }
    return [];
  }

  static String _integerToSmufl(int num) {
    final unicodeValue = 0xE080 + num;
    return String.fromCharCode(unicodeValue);
  }

  VisualMusicElement transpose(int positions) {
    var position = ElementPosition.fromInt(
      this.position.numericPosition + positions,
    );

    return copyWith(position: position);
  }

  VisualMusicElement copyWith({
    String? symbol,
    ElementPosition? position,
    bool? influencedByClef,
    Offset? defaultOffsetG4,
  }) =>
      VisualMusicElement(
        equivalent: equivalent,
        symbol: symbol ?? this.symbol,
        position: position ?? this.position,
        influencedByClef: influencedByClef ?? this.influencedByClef,
        defaultOffsetG4: defaultOffsetG4 ?? _defaultOffsetG4,
      );
}

class VisualKeyElement extends VisualMusicElement {
  VisualKeyElement({
    required super.equivalent,
    required super.symbol,
    required super.position,
    super.defaultOffsetG4,
  }) : super(
          influencedByClef: true,
          defaultMargins: HorizontalMargins(left: 10, right: 14),
        );

  static List<VisualMusicElement> fromTraditionalKey(TraditionalKey key) {
    if (key.fifths == 0) {
      return [];
    }

    int fifths = key.fifths.abs();

    // Find the starting note name based on the number of fifths
    const List<String> sharpKeys = ['F5', 'C5', 'G5', 'D5', 'A4', 'E5', 'B4'];
    const List<String> flatKeys = ['B4', 'E5', 'A4', 'D5', 'G4', 'C5', 'F4'];

    List<String> keys = key.fifths >= 0 ? sharpKeys : flatKeys;
    keys = keys.sublist(0, fifths);

    return keys
        .map(
          (k) => VisualKeyElement(
            equivalent: key,
            symbol: key.fifths >= 0
                ? Accidentals.accidentalSharp.codepoint
                : Accidentals.accidentalFlat.codepoint,
            position: ElementPosition(
              step: Step.fromString(k[0])!,
              octave: int.parse(k[1]),
            ),
            defaultOffsetG4: const Offset(0, -5),
          ),
        )
        .toList();
  }

  @override
  VisualMusicElement transpose(int positions) {
    var position = ElementPosition.fromInt(
      this.position.numericPosition + positions - 14,
    );

    return _copyWith(position: position);
  }

  VisualKeyElement _copyWith({
    String? symbol,
    ElementPosition? position,
    Offset? defaultOffsetG4,
  }) =>
      VisualKeyElement(
        equivalent: equivalent,
        symbol: symbol ?? this.symbol,
        position: position ?? this.position,
        defaultOffsetG4: defaultOffsetG4 ?? _defaultOffsetG4,
      );
}
