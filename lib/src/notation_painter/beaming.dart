import 'package:flutter/widgets.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/time.dart';
import 'package:music_notation/src/models/elements/music_data/note/beam.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/models/elements/music_data/note/stem.dart';
import 'package:music_notation/src/notation_painter/chord_element.dart';
import 'package:music_notation/src/notation_painter/measure/measure_element.dart';
import 'package:music_notation/src/notation_painter/notation_layout_properties.dart';
import 'package:music_notation/src/notation_painter/note_element.dart';
import 'package:music_notation/src/notation_painter/painters/beam_painter.dart';

class BeamElement {}

class BeamProcessing {
  final Offset? beamStartOffset;
  final Offset? beamEndOffset;
  final Widget? beam;

  BeamProcessing({
    this.beamStartOffset,
    this.beamEndOffset,
    this.beam,
  });

  static BeamProcessing evaluate({
    required MeasureWidget child,
    required int index,
    required double topOffset,
    required List<double> spacings,
    Offset? beamStartOffset,
    Offset? beamEndOffset,
  }) {
    bool isBeamStart = false;
    bool isBeamEnd = false;
    Offset? beamOffset;
    StemValue direction = StemValue.up;

    // Check if the child has an offsetForBeam property
    if (child is NoteElement) {
      var beamValue = child.note.beams.firstOrNull?.value;
      if (beamValue != null) {
        isBeamStart = beamValue == BeamValue.begin;
        isBeamEnd = beamValue == BeamValue.end;
      }
      beamOffset = child.offsetForBeam;
      direction = child.stem?.value ?? direction;
    }
    if (child is Chord) {
      var beamsList = child.notes.expand((note) => note.beams);
      isBeamStart = beamsList.any((beam) => beam.value == BeamValue.begin);
      isBeamEnd = beamsList.any((beam) => beam.value == BeamValue.end);
      beamOffset = child.offsetForBeam;
      direction = child.stem?.value ?? direction;
    }

    // Update beam offsets
    if (isBeamStart && beamOffset != null) {
      beamStartOffset = beamOffset.translate(spacings[index], topOffset);
      beamStartOffset = beamStartOffset.translate(
        -NotationLayoutProperties.stemStrokeWidth / 2,
        0,
      );

      if (direction == StemValue.down) {
        beamStartOffset = beamStartOffset.translate(
          0,
          -NotationLayoutProperties.beamThickness,
        );
      }
    }

    if (isBeamEnd && beamOffset != null) {
      beamEndOffset = beamOffset.translate(spacings[index], topOffset);
      beamEndOffset = beamEndOffset.translate(
        -NotationLayoutProperties.stemStrokeWidth / 2,
        0,
      );
      if (direction == StemValue.up) {
        beamEndOffset = beamEndOffset.translate(
          0,
          NotationLayoutProperties.beamThickness,
        );
      }
    }

    // If both beam offsets are defined, create the beam widget
    if (beamStartOffset != null && beamEndOffset != null) {
      Color? color;

      if (beamStartOffset.dy > beamEndOffset.dy) {
        beamStartOffset = beamStartOffset.translate(
          0,
          NotationLayoutProperties.beamThickness,
        );
        beamEndOffset = beamEndOffset.translate(
          0,
          -NotationLayoutProperties.beamThickness,
        );
        // color = Color.fromRGBO(255, 0, 0, 0.5);
      }

      Rect beamRect = Rect.fromPoints(beamStartOffset, beamEndOffset);

      double top = beamStartOffset.dy < beamEndOffset.dy
          ? beamStartOffset.dy
          : beamEndOffset.dy;

      Widget beam = Positioned(
        left: beamStartOffset.dx,
        top: top,
        child: CustomPaint(
          size: beamRect.size,
          painter: BeamPainter(
            color: color,
            flip: beamStartOffset.dy > beamEndOffset.dy,
          ),
        ),
      );

      return BeamProcessing(
        beam: beam,
      );
    }

    return BeamProcessing(
      beamStartOffset: beamStartOffset,
      beamEndOffset: beamEndOffset,
    );
  }
}

/// Different beat strengths typically used in music notation.
enum BeatStrength {
  strong,
  weak,
  medium,
}

/// A utility class that generates beat patterns for given time signatures.
///
/// The class contains predefined patterns for simple and compound time signatures, and
/// can be used to derive the pattern of strong, weak, and medium beats in a measure of
/// music according to the time signature.
class BeatPattern {
  /// A map of common beat patterns for simple time signatures.
  ///
  /// Each key is the beat type (the number of divisions in each beat), and the corresponding
  /// value is a list of `BeatStrength` enumerations that define the strength of each beat.
  static const Map<int, List<BeatStrength>> _simplePatterns = {
    2: [BeatStrength.strong, BeatStrength.weak],
    3: [BeatStrength.strong, BeatStrength.weak, BeatStrength.weak],
    4: [
      BeatStrength.strong,
      BeatStrength.weak,
      BeatStrength.medium,
      BeatStrength.weak
    ],
  };

  /// A map of common beat patterns for compound time signatures.
  static const Map<int, List<BeatStrength>> _compoundPatterns = {
    6: [
      BeatStrength.strong,
      BeatStrength.weak,
      BeatStrength.medium,
      BeatStrength.weak,
      BeatStrength.weak,
      BeatStrength.weak
    ],
    9: [
      BeatStrength.strong,
      BeatStrength.weak,
      BeatStrength.weak,
      BeatStrength.medium,
      BeatStrength.weak,
      BeatStrength.weak,
      BeatStrength.weak,
      BeatStrength.weak,
      BeatStrength.weak
    ],
    12: [
      BeatStrength.strong,
      BeatStrength.weak,
      BeatStrength.weak,
      BeatStrength.medium,
      BeatStrength.weak,
      BeatStrength.weak,
      BeatStrength.medium,
      BeatStrength.weak,
      BeatStrength.weak,
      BeatStrength.weak,
      BeatStrength.weak,
      BeatStrength.weak
    ],
  };

  /// Generates the beat pattern for a given [beats] and [beatType].
  ///
  /// This method returns a list of [BeatStrength] enumerations that define the
  /// strength of each beat in a measure.
  static List<BeatStrength> generate(int beats, int beatType) {
    List<BeatStrength>? beatPattern;
    if (beatType == 4) {
      beatPattern = _simplePatterns[beats];
    } else if (beatType == 8 && beats % 3 == 0) {
      beatPattern = _compoundPatterns[beats ~/ 3];
    }
    if (beatPattern != null) return beatPattern;
    throw UnimplementedError(
      "$beats/$beatType is not supported yet",
    );
  }
}

class Beaming {
  /// Returns a list of integers. Each integer corresponds to a [Note] in the
  /// provided [notes] list. Each integer in the returned list represents the ID
  /// of the beam group to which the corresponding [Note] belongs. A value of -1
  /// means that the note at the corresponding index is not part of any beam group.
  /// Note is not in a group when it is equal or longer than quarter note. These
  /// notes aren't beamed together.
  static List<int> generate({
    required List<Note> notes,
    required TimeSignature timeSignature,
    required double divisions,
  }) {
    int? beats = int.tryParse(timeSignature.beats);

    if (beats == null) {
      throw ArgumentError.value(
        timeSignature.beats,
        "timeSignature.beats",
        "TimeSignature argument must have 'beats' that can be parsed to integer",
      );
    }

    int? beatType = int.tryParse(timeSignature.beatType);

    if (beatType == null) {
      throw ArgumentError.value(
        timeSignature.beatType,
        "timeSignature.beatType",
        "TimeSignature argument must have 'beatType' that can be parsed to integer",
      );
    }
    // Will be used in future.
    // ignore: unused_local_variable
    var beatPattern = BeatPattern.generate(beats, beatType);
    var notesGroups = List.filled(notes.length, -1);

    int groupId = 0;

    double durationPerBeat = (beatType / 4) * divisions;
    // double durationPerMeasure = durationPerBeat * beats;

    double currentDuration = 0;

    for (var i = 0; i < notes.length; i++) {
      if (notes[i] is! RegularNote) {
        UnimplementedError("Only regular note rendering is implemented");
      }

      var note = notes[i] as RegularNote;

      // If the note is not a rest and its duration is smaller than a quarter note,
      // it is part of a beam group.
      if (note.form is! Rest && note.duration < divisions) {
        double noteDuration = note.duration;
        currentDuration += noteDuration;
        notesGroups[i] = groupId;
      }
      // If the current duration exceeds or equals a beat, or if the note is a
      // rest, reset the current duration and increment the group ID.
      if (currentDuration >= durationPerBeat || note.form is Rest) {
        currentDuration = 0;
        groupId++;
      }
    }
    return notesGroups;
  }
}
