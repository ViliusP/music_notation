import 'package:music_notation/models/instruments.dart';

/// The instrument-change element type represents a change to the virtual instrument sound for a given score-instrument.
///
/// The id attribute refers to the score-instrument affected by the change.
///
/// All instrument-change child elements can also be initially specified within the score-instrument element.
class InstrumentChange {
  /// Refers to the <score-instrument> affected by the change.
  String id;

  VirtualInstrumentData instrumentData;

  InstrumentChange({
    required this.id,
    required this.instrumentData,
  });
}
