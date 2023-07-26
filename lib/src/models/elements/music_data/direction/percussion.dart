import 'package:music_notation/src/models/elements/music_data/direction/direction.dart';
import 'package:xml/xml.dart';

/// The percussion element is used to define percussion pictogram symbols.
///
/// Definitions for these symbols can be found in Kurt Stone's "Music Notation in the Twentieth Century"
/// on pages 206-212 and 223.
///
/// Some values are added to these based on how usage has evolved in the 30 years
/// since Stone's book was published.
class Percussion implements DirectionType {
  factory Percussion.fromXml(XmlElement xmlElement) {
    throw UnimplementedError();
  }
}

abstract class PercussionValueFromXml {}

class PercussionType<T extends PercussionValueFromXml> implements Percussion {
  T value;

  ///	Distinguishes different SMuFL stylistic alternates.
  String? smufl;

  PercussionType({
    required this.value,
    required this.smufl,
  });

  static PercussionType fromXml(XmlElement xmlElement) {
    return PercussionType<GlassValue>(
      value: GlassValue.glassHarmonica,
      smufl: null,
    );
  }
}

// /// The glass type represents pictograms for glass percussion instruments.
// ///
// /// The smufl attribute is used to distinguish different SMuFL glyphs for wind chimes in the Chimes pictograms range,
// /// including those made of materials other than glass.
// class Glass extends PercussionType<GlassValue> {
//   Glass({
//     required super.value,
//     required super.smufl,
//   });
// }

/// The glass-value type represents pictograms for glass percussion instruments.
enum GlassValue implements PercussionValueFromXml {
  glassHarmonica,
  glassHarp,
  windChimes;
}

/// The metal-value type represents pictograms for metal percussion instruments.
///
/// The hi-hat value refers to a pictogram like Stone's high-hat cymbals
/// but without the long vertical line at the bottom.
enum MetalValue implements PercussionValueFromXml {
  agogo,
  almglocken,
  bell,
  bellPlate,
  bellTree,
  brakeDrum,
  cencerro,
  chainRattle,
  chineseCymbal,
  cowbell,
  crashCymbals,
  crotale,
  cymbalTongs,
  domedGong,
  fingerCymbals,
  flexatone,
  gong,
  hiHat,
  highHatCymbals,
  handbell,
  jawHarp,
  jingleBells,
  musicalSaw,
  shellBells,
  sistrum,
  sizzleCymbal,
  sleighBells,
  suspendedCymbal,
  tamTam,
  tamTamWithBeater,
  triangle,
  vietnameseHat;
}

// /// The wood type represents pictograms for wood percussion instruments.
// ///
// /// The smufl attribute is used to distinguish different SMuFL stylistic alternates.
// class Wood implements Percussion {
//   WoodValue value;
//   String smufl;

//   Wood({
//     required this.value,
//     required this.smufl,
//   });
// }

/// The wood-value type represents pictograms for wood percussion instruments.
///
/// The maraca and maracas values distinguish the one- and two-maraca versions of the pictogram.
enum WoodValue implements PercussionValueFromXml {
  bambooScraper,
  boardClapper,
  cabasa,
  castanets,
  castanetsWithHandle,
  claves,
  footballRattle,
  guiro,
  logDrum,
  maraca,
  maracas,
  quijada,
  rainstick,
  ratchet,
  recoReco,
  sandpaperBlocks,
  slitDrum,
  templeBlock,
  vibraslap,
  whip,
  woodBlock;
}

// class Pitched implements Percussion {
//   PitchedValue value;
//   String smufl;

//   Pitched({
//     required this.value,
//     required this.smufl,
//   });
// }

/// The membrane-value type represents pictograms for membrane percussion instruments.
enum MembraneValue implements PercussionValueFromXml {
  bassDrum,
  bassDrumOnSide,
  bongos,
  chineseTomtom,
  congaDrum,
  cuica,
  gobletDrum,
  indoAmericanTomtom,
  japaneseTomtom,
  militaryDrum,
  snareDrum,
  snareDrumSnaresOff,
  tabla,
  tambourine,
  tenorDrum,
  timbales,
  tomtom;
}

/// The effect-value type represents pictograms for sound effect percussion instruments.
///
/// The cannon, lotus flute, and megaphone values are in addition to Stone's list.
enum EffectValue implements PercussionValueFromXml {
  anvil,
  autoHorn,
  birdWhistle,
  cannon,
  duckCall,
  gunShot,
  klaxonHorn,
  lionsRoar,
  lotusFlute,
  megaphone,
  policeWhistle,
  siren,
  slideWhistle,
  thunderSheet,
  windMachine,
  windWhistle;
}

enum BeaterValue implements PercussionValueFromXml {
  bow,
  chimeHammer,
  coin,
  drumStick,
  finger,
  fingernail,
  fist,
  guiroScraper,
  hammer,
  hand,
  jazzStick,
  knittingNeedle,
  metalHammer,
  slideBrushOnGong,
  snareStick,
  spoonMallet,
  superball,
  triangleBeater,
  triangleBeaterPlain,
  wireBrush;
}

/// Represents pictograms for pitched percussion instruments.
///
/// The smufl attribute is used to distinguish different SMuFL glyphs
/// for a particular pictogram within the Tuned mallet percussion pictograms range.
class Pitched {
  /// type="smufl-pictogram-glyph-name"
  ///
  /// See more at [SmuflPictogramGlyphName].
  String smufl;

  PitchedValue value;

  Pitched({
    required this.smufl,
    required this.value,
  });
}

/// Represents pictograms for pitched percussion instruments.
///
/// The chimes and tubular chimes values distinguish the single-line
/// and double-line versions of the pictogram.
enum PitchedValue {
  celesta,
  chimes,
  glockenspiel,
  lithophone,
  mallet,
  marimba,
  steelDrums,
  tubaphone,
  tubularChimes,
  vibraphone,
  xylophone;
}
