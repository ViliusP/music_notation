import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/time.dart';
import 'package:music_notation/src/models/elements/music_data/note/beam.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/models/elements/music_data/note/stem.dart';
import 'package:music_notation/src/notation_painter/chord_element.dart';
import 'package:music_notation/src/notation_painter/measure/inherited_padding.dart';
import 'package:music_notation/src/notation_painter/measure/measure_element.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/notation_layout_properties.dart';
import 'package:music_notation/src/notation_painter/note_element.dart';
import 'package:music_notation/src/notation_painter/painters/beam_painter.dart';

class BeamGroup extends StatelessWidget {
  final List<MeasureWidget> children;
  final List<double> leftOffsets;

  const BeamGroup({
    super.key,
    required this.children,
    required this.leftOffsets,
  });

  factory BeamGroup.fromBeaming(BeamGrouping beaming) {
    return BeamGroup(
      leftOffsets: beaming._leftOffsets,
      children: beaming._group,
    );
  }

  Size _beamSize() {
    const offsetPerPosition = NotationLayoutProperties.staveSpace / 2;

    MeasureWidget first = children.first;
    MeasureWidget last = children.last;

    ElementPosition? firstPosition;
    ElementPosition? lastPosition;

    Offset? firstBeamOffset;
    Offset? lastBeamOffset;

    double firstStemLength = 0;
    double lastStemLength = 0;

    if (first is NoteElement) {
      firstPosition = first.position;
      firstBeamOffset = first.offsetForBeam;
      firstStemLength = first.stemLength;
    }
    if (first is Chord) {
      firstPosition = first.position;
      firstBeamOffset = first.offsetForBeam;
      firstStemLength = first.stemLength;
    }
    if (last is NoteElement) {
      lastPosition = last.position;
      lastBeamOffset = last.offsetForBeam;
      lastStemLength = last.stemLength;
    }
    if (last is Chord) {
      lastPosition = last.position;
      lastBeamOffset = last.offsetForBeam;
      lastStemLength = last.stemLength;
    }

    double beamCanvasHeight =
        offsetPerPosition * firstPosition!.distance(lastPosition!);

    beamCanvasHeight += (firstBeamOffset!.dy - lastBeamOffset!.dy);
    beamCanvasHeight += NotationLayoutProperties.beamThickness;
    beamCanvasHeight -= (lastStemLength - firstStemLength);

    return Size(
      leftOffsets.last - leftOffsets.first,
      beamCanvasHeight,
    );
  }

  bool _isBeamDownward() {
    MeasureWidget first = children.first;
    MeasureWidget last = children.last;

    ElementPosition? firstPosition;
    ElementPosition? lastPosition;

    if (first is NoteElement) {
      firstPosition = first.position;
    }
    if (first is Chord) {
      firstPosition = first.position;
    }
    if (last is NoteElement) {
      lastPosition = last.position;
    }
    if (last is Chord) {
      lastPosition = last.position;
    }

    return firstPosition! > lastPosition!;
  }

  @override
  Widget build(BuildContext context) {
    final List<double> topOffsets = [];

    const offsetPerPosition = NotationLayoutProperties.staveSpace / 2;
    final inheritedPadding = InheritedPadding.of(context);
    if (inheritedPadding == null) return SizedBox.shrink();

    for (var child in children) {
      double topOffset = -child.verticalAlignmentAxisOffset;

      // Calculate the interval from staff bottom to the child's position.
      int intervalFromTheTop = ElementPosition.staffTop.numeric;
      intervalFromTheTop -= (child.position.numeric);
      topOffset += intervalFromTheTop * offsetPerPosition;
      topOffsets.add(topOffset);
    }

    double beamLeftOffset = 0;

    MeasureWidget first = children.first;
    StemValue? stemValue;

    if (first is NoteElement) {
      beamLeftOffset = first.offsetForBeam.dx;
      stemValue = first.stem!.value;
    }
    if (first is Chord) {
      beamLeftOffset = first.offsetForBeam.dx;
      stemValue = first.stem!.value;
    }

    double? beamTopOffset;
    if (stemValue == StemValue.up) {
      beamTopOffset = 0;
      beamTopOffset += inheritedPadding.top;
      if (!_isBeamDownward()) {
        beamTopOffset += topOffsets[0];
      }
      if (_isBeamDownward()) {
        beamTopOffset += topOffsets.last;
      }
      beamTopOffset -= _beamSize().height;
      beamTopOffset += NotationLayoutProperties.beamThickness;
    }

    double? beamBottomOffset;
    if (stemValue == StemValue.down) {
      beamBottomOffset = 0;
      beamBottomOffset += inheritedPadding.bottom;
      if (!_isBeamDownward()) {
        beamBottomOffset -= topOffsets[0];
      }
      if (_isBeamDownward()) {
        beamBottomOffset -= topOffsets.last;
      }
    }

    return Stack(
      fit: StackFit.loose,
      children: [
        ...children.mapIndexed(
          (i, x) => Positioned(
            left: leftOffsets[i],
            top: inheritedPadding.top + topOffsets[i],
            child: x,
          ),
        ),
        Positioned(
          left: leftOffsets[0] + beamLeftOffset,
          top: beamTopOffset,
          bottom: beamBottomOffset,
          child: CustomPaint(
            size: _beamSize(),
            painter: BeamPainter(
              // color: color,
              downward: _isBeamDownward(),
            ),
          ),
        ),
      ],
    );
  }
}

// class NoteBeam {
//   final List<BeamValue> beams;
// }

// class BeamGroup {
//   List<NoteBeam>
// }

class BeamGrouping {
  final List<MeasureWidget> _group = [];
  final List<double> _leftOffsets = [];

  final bool _strictAddition = true;

  bool _isFinalized = false;

  BeamGrouping();

  bool get isFinalized => _isFinalized;

  /// Maybe it is already finally evaluated group or not, depends on implementer. Check [add] function and [isFinalized].
  List<MeasureWidget> get tentativeGroup => _group;

  /// Returns [BeamingResult] after addition of provided [element].
  BeamingResult add(MeasureWidget element, double leftOffset) {
    BeamValue? beamValue;

    if (isFinalized) {
      return BeamingResult.skippedAndFinished;
    }

    if (element is! NoteElement && element is! Chord) {
      return BeamingResult.skipped;
    }

    if (element is NoteElement) {
      beamValue = element.note.beams.firstOrNull?.value;
    }
    if (element is Chord) {
      var beamsList = element.notes.expand((note) => note.beams);
      beamValue = beamsList.firstOrNull?.value;
    }

    if (beamValue == null) {
      return BeamingResult.skipped;
    }

    if (_group.isNotEmpty && beamValue == BeamValue.begin) {
      return BeamingResult.skipped;
    }

    _group.add(element);
    _leftOffsets.add(leftOffset);

    if (!isFinalized && beamValue == BeamValue.end) {
      _isFinalized = true;
      return BeamingResult.finished;
    }

    return BeamingResult.added;
  }
}

enum BeamingResult {
  added,
  skipped,
  finished,
  skippedAndFinished;
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
