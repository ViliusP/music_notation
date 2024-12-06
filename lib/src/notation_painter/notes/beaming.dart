import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/time.dart';
import 'package:music_notation/src/models/elements/music_data/note/beam.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/notation_painter/models/vertical_edge_insets.dart';
import 'package:music_notation/src/notation_painter/notes/chord_element.dart';
import 'package:music_notation/src/notation_painter/measure/measure_element.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/properties/layout_properties.dart';
import 'package:music_notation/src/notation_painter/notes/note_element.dart';
import 'package:music_notation/src/notation_painter/notes/rhythmic_element.dart';
import 'package:music_notation/src/notation_painter/notes/stemming.dart';
import 'package:music_notation/src/notation_painter/painters/beam_painter.dart';
import 'package:music_notation/src/notation_painter/properties/notation_properties.dart';
import 'package:music_notation/src/notation_painter/utilities/number_extensions.dart';
import 'package:music_notation/src/notation_painter/utilities/size_extensions.dart';

class BeamContainer extends StatefulWidget {
  final Widget child;

  /// [listenables] could be [ScrollController] and alike, in order for
  /// the arrows to repaint when moving in a scrollable widget.
  final List<Listenable> listenables;

  const BeamContainer({
    super.key,
    required this.child,
    this.listenables = const [],
  });

  @override
  State<BeamContainer> createState() => _BeamContainerState();
}

class _BeamContainerState extends State<BeamContainer> with ChangeNotifier {
  final _notes = <String, _BeamNoteElementState>{};

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          widget.child,
          IgnorePointer(
            child: CustomPaint(
              // foregroundPainter: BeamPainter(
              //   _notes,
              //   Directionality.of(context),
              //   [this, ...widget.listenables],
              // ),
              child: Container(),
            ),
          ),
        ],
      );

  void addNote(_BeamNoteElementState note) {
    _notes[note.widget.id] = note;
    notifyListeners();
  }

  void removeNote(_BeamNoteElementState note) {
    if (_notes[note.widget.id] == note) {
      _notes.remove(note.widget.id);
    }

    if (mounted) {
      notifyListeners();
    }
  }
}

class BeamNoteElement extends StatefulWidget {
  /// ID for being targeted by other [BeamNoteElement]s
  final String id;

  /// A ID of [BeamNoteElement] that will be drawn to
  final String? target;

  /// A [Widget] to be drawn to or from
  final Widget child;

  const BeamNoteElement({
    super.key,
    required this.id,
    this.target,
    required this.child,
  });

  @override
  State createState() => _BeamNoteElementState();
}

class _BeamNoteElementState extends State<BeamNoteElement> {
  _BeamContainerState? _container;

  @override
  void initState() {
    super.initState();
    joinAncestorContainer();
  }

  @override
  void didUpdateWidget(BeamNoteElement oldWidget) {
    super.didUpdateWidget(oldWidget);
    joinAncestorContainer();
  }

  void joinAncestorContainer() {
    _container = context.findAncestorStateOfType<_BeamContainerState>()
      ?..addNote(this);
  }

  @override
  void deactivate() {
    _container?.removeNote(this);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class BeamGroup extends StatelessWidget {
  final List<RhythmicElement> children;
  final List<double> leftOffsets;
  final VerticalEdgeInsets padding;

  const BeamGroup({
    super.key,
    required this.children,
    required this.leftOffsets,
    required this.padding,
  });

  factory BeamGroup.fromBeaming(
    BeamGroupV2 beaming,
    VerticalEdgeInsets padding,
  ) {
    return BeamGroup(
      leftOffsets: beaming._positions.map((p) => p.left).toList(),
      padding: padding,
      children: beaming._elements,
    );
  }

  Size get _baseBeamSize {
    const spacePerPosition = NotationLayoutProperties.baseSpacePerPosition;

    ElementPosition? firstPosition;
    ElementPosition? lastPosition;

    double firstStemLength = 0;
    double lastStemLength = 0;

    firstPosition = children.first.position;
    firstStemLength = children.first.stemLength;

    lastPosition = children.last.position;
    lastStemLength = children.last.stemLength;

    double canvasHeight =
        spacePerPosition * firstPosition.distance(lastPosition);

    canvasHeight += NotationLayoutProperties.baseBeamThickness;
    canvasHeight -= (lastStemLength - firstStemLength);

    double canvasWidth = leftOffsets.last - leftOffsets.first;
    canvasWidth -= (NotationLayoutProperties.baseStemStrokeWidth / 2);

    return Size(canvasWidth, canvasHeight);
  }

  BeamDirection get _isBeamDownward {
    if (children.first.position > children.last.position) {
      return BeamDirection.downward;
    }
    return BeamDirection.upward;
  }

  List<BeamNoteData> beamsPattern(BuildContext context) {
    List<BeamNoteData> pattern = [];
    for (var (i, child) in children.indexed) {
      if (child is NoteElement) {
        pattern.add(BeamNoteData(
          beams: child.beams,
          leftOffset:
              (leftOffsets[i] - leftOffsets[0]).scaledByContext(context),
          stemDirection: child.stemDirection!,
        ));
      }
      if (child is Chord) {
        pattern.add(BeamNoteData(
          beams: child.notes.firstWhere((x) => x.beams.isNotEmpty).beams,
          leftOffset:
              (leftOffsets[i] - leftOffsets[0]).scaledByContext(context),
          stemDirection: child.stemDirection!,
        ));
      }
    }
    return pattern;
  }

  @override
  Widget build(BuildContext context) {
    NotationLayoutProperties layoutProperties =
        NotationProperties.of(context)?.layout ??
            NotationLayoutProperties.standard();

    double beamThickness = layoutProperties.beamThickness;

    List<({double? bottom, double? top})> verticalOffsets = [];

    double spacePerPosition = layoutProperties.spacePerPosition;

    for (var child in children) {
      double? topOffset;
      double? bottomOffset;

      var alignmentPosition = child.alignmentPosition.scale(
        layoutProperties.staveSpace,
      );

      if (alignmentPosition.top != null) {
        topOffset = 0;
        topOffset = alignmentPosition.top!;

        // Calculate the interval from staff top to the child's position.
        int intervalFromTheF5 = ElementPosition.staffTop.numeric;
        intervalFromTheF5 -= child.position.numeric;
        topOffset += intervalFromTheF5 * spacePerPosition;

        topOffset += padding.top;
      }
      if (alignmentPosition.bottom != null) {
        bottomOffset = 0;
        bottomOffset = alignmentPosition.bottom!;

        // Calculate the interval from staff bottom to the child's position.
        int intervalFromTheE4 = ElementPosition.staffBottom.numeric;
        intervalFromTheE4 -= child.position.numeric;
        bottomOffset -= intervalFromTheE4 * spacePerPosition;

        bottomOffset += padding.bottom;
      }

      verticalOffsets.add((bottom: bottomOffset, top: topOffset));
    }

    Offset? firstNoteBeamOffset = Offset(0, 0);
    Offset? lastNoteBeamOffset = Offset(0, 0);

    RhythmicElement first = children.first;
    RhythmicElement last = children.last;

    StemDirection? firstNoteStemValue;
    // StemValue? lastNoteStemValue;

    firstNoteBeamOffset = first.offsetForBeam.scale(
      layoutProperties.staveSpace,
      layoutProperties.staveSpace,
    );
    firstNoteStemValue = first.stemDirection;

    lastNoteBeamOffset = last.offsetForBeam.scale(
      layoutProperties.staveSpace,
      layoutProperties.staveSpace,
    );

    double? beamTopOffset;
    if (verticalOffsets[0].top != null) {
      beamTopOffset = 0;
      // TODO: fix second check
      if (first.position < last.position && verticalOffsets.last.top != null) {
        beamTopOffset += verticalOffsets.last.top!;
        beamTopOffset += lastNoteBeamOffset.dy;
      }
      if (first.position >= last.position) {
        beamTopOffset += verticalOffsets.first.top!;
        beamTopOffset += firstNoteBeamOffset.dy;
      }
      if (firstNoteStemValue == StemDirection.down) {
        beamTopOffset -= beamThickness;
      }
    }

    double? beamBottomOffset;
    if (verticalOffsets[0].bottom != null) {
      beamBottomOffset = 0;
      if (first.position < last.position) {
        beamBottomOffset += verticalOffsets.first.bottom!;
        beamBottomOffset += firstNoteBeamOffset.dy;
      }
      if (first.position >= last.position) {
        beamBottomOffset += lastNoteBeamOffset.dy;
        beamBottomOffset += verticalOffsets.last.bottom!;
      }
      beamBottomOffset -= beamThickness;
    }

    return Stack(
      fit: StackFit.loose,
      children: [
        ...children.mapIndexed(
          (i, x) => Positioned(
            left: leftOffsets[i].scaledByContext(context),
            bottom: verticalOffsets[i].bottom,
            top: verticalOffsets[i].top,
            child: x,
          ),
        ),
        Positioned(
          left:
              leftOffsets[0].scaledByContext(context) + firstNoteBeamOffset.dx,
          top: beamTopOffset,
          bottom: beamBottomOffset,
          child: CustomPaint(
            size: _baseBeamSize.scale(layoutProperties.staveSpace),
            painter: BeamPainter(
              beamsPattern: beamsPattern(context),
              // color: color,
              direction: _isBeamDownward,
              hookLength: layoutProperties.staveSpace,
              thickness: beamThickness,
              spacing: layoutProperties.beamSpacing,
            ),
          ),
        ),
      ],
    );
  }
}

class BeamNoteData {
  final List<Beam> beams;
  final StemDirection stemDirection;
  final double leftOffset;

  BeamNoteData({
    required this.beams,
    required this.leftOffset,
    required this.stemDirection,
  });
}

enum BeamDirection { downward, upward }

class BeamCanvas extends StatelessWidget {
  final List<BeamData> beams;

  const BeamCanvas({super.key, required this.beams});

  @override
  Widget build(BuildContext context) {
    NotationLayoutProperties layoutProperties =
        NotationProperties.of(context)?.layout ??
            NotationLayoutProperties.standard();

    double beamThickness = layoutProperties.beamThickness;

    return Stack(
      children: beams
          .map(
            (b) => AlignmentPositioned(
              position: b.startPosition.scale(layoutProperties.staveSpace),
              child: CustomPaint(
                size: b.size.scale(layoutProperties.staveSpace),
                painter: BeamPainter(
                  beamsPattern: b.scaledPattern(layoutProperties.staveSpace),
                  // color: color,
                  hookLength: layoutProperties.staveSpace,
                  thickness: beamThickness,
                  spacing: layoutProperties.beamSpacing,
                  direction: b.direction,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class BeamGroupV2 {
  final List<RhythmicElement> _elements = [];
  final List<AlignmentPosition> _positions = [];

  bool _isFinalized = false;

  bool get isFinalized => _isFinalized;

  BeamGroupV2();

  /// Returns [BeamingResult] after addition of provided [element].
  BeamingResult add(RhythmicElement element, AlignmentPosition position) {
    BeamValue? beamValue;

    if (isFinalized) {
      return BeamingResult.skippedAndFinished;
    }

    if (element is NoteElement) {
      beamValue = element.beams.firstOrNull?.value;
    }
    if (element is Chord) {
      var beamsList = element.notes.expand((note) => note.beams);
      beamValue = beamsList.firstOrNull?.value;
    }

    if (beamValue == null) {
      return BeamingResult.skipped;
    }

    if (_elements.isNotEmpty && beamValue == BeamValue.begin) {
      return BeamingResult.skipped;
    }

    _elements.add(element);
    _positions.add(position);

    if (!isFinalized && beamValue == BeamValue.end) {
      _isFinalized = true;
      return BeamingResult.finished;
    }

    return BeamingResult.added;
  }

  List<BeamNoteData> get _beamPattern {
    List<BeamNoteData> pattern = [];
    for (var (i, child) in _elements.indexed) {
      if (child is NoteElement) {
        pattern.add(BeamNoteData(
          beams: child.beams,
          leftOffset: _positions[i].left - _positions[0].left,
          stemDirection: child.stemDirection!,
        ));
      }
      if (child is Chord) {
        pattern.add(BeamNoteData(
          beams: child.notes.firstWhere((x) => x.beams.isNotEmpty).beams,
          leftOffset: _positions[i].left - _positions[0].left,
          stemDirection: child.stemDirection!,
        ));
      }
    }
    return pattern;
  }

  BeamDirection get _beamDirection {
    if (_elements.first.position > _elements.last.position) {
      return BeamDirection.downward;
    }
    return BeamDirection.upward;
  }

  Size get _beamSize {
    const spacePerPosition = NotationLayoutProperties.baseSpacePerPosition;

    ElementPosition? firstPosition;
    ElementPosition? lastPosition;

    double firstStemLength = 0;
    double lastStemLength = 0;

    firstPosition = _elements.first.position;
    firstStemLength = _elements.first.stemLength;

    lastPosition = _elements.last.position;
    lastStemLength = _elements.last.stemLength;

    double canvasHeight =
        spacePerPosition * firstPosition.distance(lastPosition);

    canvasHeight += NotationLayoutProperties.baseBeamThickness;
    canvasHeight -= (lastStemLength - firstStemLength);

    double canvasWidth = _positions.last.left - _positions.first.left;
    canvasWidth -= (NotationLayoutProperties.baseStemStrokeWidth / 2);

    return Size(canvasWidth, canvasHeight);
  }

  /// Provide notes relative position in canvas.
  AlignmentPosition _beamStartPosition() {
    RhythmicElement first = _elements.first;
    RhythmicElement last = _elements.last;

    StemDirection? firstNoteStemValue;

    Offset firstNoteBeamOffset = first.offsetForBeam;
    Offset lastNoteBeamOffset = last.offsetForBeam;

    firstNoteStemValue = first.stemDirection;

    double? beamTopOffset;
    if (_positions.first.top != null) {
      beamTopOffset = 0;
      // TODO: fix second check
      if (first.position < last.position && _positions.last.top != null) {
        beamTopOffset += _positions.last.top!;
        beamTopOffset += lastNoteBeamOffset.dy;
      }
      if (first.position >= last.position) {
        beamTopOffset += _positions.first.top!;
        beamTopOffset += firstNoteBeamOffset.dy;
      }
      if (firstNoteStemValue == StemDirection.down) {
        beamTopOffset -= NotationLayoutProperties.baseBeamThickness;
      }
    }

    double? beamBottomOffset;
    if (_positions.first.bottom != null) {
      beamBottomOffset = 0;
      if (first.position < last.position) {
        beamBottomOffset += _positions.first.bottom!;
        beamBottomOffset += firstNoteBeamOffset.dy;
      }
      if (first.position >= last.position) {
        beamBottomOffset += lastNoteBeamOffset.dy;
        beamBottomOffset += _positions.last.bottom!;
      }
      beamBottomOffset -= NotationLayoutProperties.baseBeamThickness;
    }
    return AlignmentPosition(
      left: _positions.first.left + _elements[0].offsetForBeam.dx,
      top: beamTopOffset,
      bottom: beamBottomOffset,
    );
  }
}

class BeamData {
  final List<BeamNoteData> pattern;

  List<BeamNoteData> scaledPattern(double scale) {
    return pattern
        .map((data) => BeamNoteData(
              beams: data.beams,
              leftOffset: data.leftOffset * scale,
              stemDirection: data.stemDirection,
            ))
        .toList();
  }

  final Size size;

  final BeamDirection direction;

  final AlignmentPosition startPosition;

  BeamData._({
    required this.pattern,
    required this.size,
    required this.direction,
    required this.startPosition,
  });

  factory BeamData.fromBeamGroup({
    required BeamGroupV2 group,
  }) {
    return BeamData._(
      pattern: group._beamPattern,
      size: group._beamSize,
      direction: group._beamDirection,
      startPosition: group._beamStartPosition(),
    );
  }
}

enum BeamingResult {
  added,
  skipped,
  finished,
  skippedAndFinished;
}

/// ------------------------------------------------------------
/// UNUSED
/// ------------------------------------------------------------

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
