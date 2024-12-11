import 'package:collection/collection.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/time.dart';
import 'package:music_notation/src/models/elements/music_data/note/beam.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/notation_painter/notes/simple_note_element.dart';
import 'package:music_notation/src/notation_painter/notes/stemming.dart';
import 'package:music_notation/src/notation_painter/painters/beam_painter.dart';
import 'package:music_notation/src/notation_painter/properties/layout_properties.dart';
import 'package:music_notation/src/notation_painter/properties/notation_properties.dart';

typedef StemBeamBoxes = ({BeamElementRenderBox beam, BeamStemRenderBox stem});

class NoteBeamData {
  final List<Beam> beams;
  final Offset offset;

  NoteBeamData({
    required this.beams,
    required this.offset,
  });
}

enum BeamType {
  /// Beam drawn from start to end point.
  full,

  /// Beam drawn from start point, to length of provided hook.
  forwardHook,

  /// Beam drawn from end point, backwardly of  of provided hook length.
  backwardHook,
}

class BeamData {
  /// Position of first stem in beamed group.
  final Offset start;

  /// Position of last stem in beamed group.
  final Offset end;

  /// Type of beam between two stems.
  final BeamType type;

  BeamData({
    required this.start,
    required this.end,
    required this.type,
  });
}

class BeamGroupData {
  /// key: level (number) of bea
  /// value: list of Beam start, end position and it's type.
  final Map<int, List<BeamData>> map;

  BeamGroupData({required this.map});

  factory BeamGroupData.fromNotesBeams(List<NoteBeamData> data) {
    // For Full beam.
    Map<int, Offset> lastBegin = {};

    // For backward and forward hook.
    Map<int, List<Offset>> offsets = {};

    // For foward hook.
    Map<int, bool> lastWasForwardHook = {};

    final Map<int, List<BeamData>> map = {};
    for (var noteBeam in data) {
      for (var beam in noteBeam.beams) {
        if (lastWasForwardHook[beam.number] == true &&
            offsets[beam.number]?.isNotEmpty == true) {
          map[beam.number] ??= [];
          map[beam.number]?.add(BeamData(
            start: offsets[beam.number]!.last,
            end: noteBeam.offset,
            type: BeamType.forwardHook,
          ));
          lastWasForwardHook.remove(beam.number);
        }

        switch (beam.value) {
          case BeamValue.begin:
            lastBegin[beam.number] = noteBeam.offset;
            break;
          case BeamValue.end:
            if (lastBegin[beam.number] != null) {
              map[beam.number] ??= [];
              map[beam.number]?.add(BeamData(
                start: lastBegin[beam.number]!,
                end: noteBeam.offset,
                type: BeamType.full,
              ));
            }
            lastBegin.remove(beam.number);
            break;

          case BeamValue.bContinue:
            break;
          case BeamValue.forwardHook:
            lastWasForwardHook[beam.number] = true;
            break;
          case BeamValue.backwardHook:
            if (offsets[beam.number]?.lastOrNull != null) {
              map[beam.number] ??= [];
              map[beam.number]?.add(BeamData(
                start: offsets[beam.number]!.last,
                end: noteBeam.offset,
                type: BeamType.full,
              ));
            }
            break;
        }
        offsets[beam.number] ??= [];
        offsets[beam.number]?.add(noteBeam.offset);
      }
    }
    var uniqueBeamNumbers = data
        .expand((noteBeam) => noteBeam.beams)
        .map((beam) => beam.number)
        .toSet();

    for (var number in uniqueBeamNumbers) {
      if (lastWasForwardHook[number] == true) {
        map[number] ??= [];
        map[number]?.add(BeamData(
          start: offsets[number]![offsets[number]!.length - 2],
          end: offsets[number]!.last,
          type: BeamType.forwardHook,
        ));
      }
    }

    return BeamGroupData(map: map);
  }
}

enum BeamDirection { downward, upward }

class BeamElement extends SingleChildRenderObjectWidget {
  final List<Beam> beams;

  const BeamElement({
    super.key,
    required this.beams,
    required super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return BeamElementRenderBox(beams: beams);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    BeamElementRenderBox renderObject,
  ) {
    renderObject.beams = beams;
  }
}

class BeamElementRenderBox extends RenderProxyBox {
  List<Beam> beams;

  BeamElementRenderBox({required this.beams});

  @override
  void performLayout() {
    // Layout the child with loosened constraints
    if (child != null) {
      child!.layout(constraints.loosen(), parentUsesSize: true);
    }

    // Set the size of the wrapper based on the child or a default
    size = constraints.constrain(Size(
      child?.size.width ?? 0,
      child?.size.height ?? 0,
    ));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // Paint the child
    if (child != null) {
      context.paintChild(child!, offset);
    }
  }
}

class BeamCanvas extends SingleChildRenderObjectWidget {
  const BeamCanvas({
    super.key,
    required super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    NotationLayoutProperties layoutProperties =
        NotationProperties.of(context)?.layout ??
            NotationLayoutProperties.standard();

    return BeamCanvasRenderBox(
      beamThickness: layoutProperties.beamThickness,
      spacingBetweenBeams: layoutProperties.beamSpacing,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    BeamCanvasRenderBox renderObject,
  ) {
    NotationLayoutProperties layoutProperties =
        NotationProperties.of(context)?.layout ??
            NotationLayoutProperties.standard();
    renderObject.beamThickness = layoutProperties.beamThickness;
    renderObject.spacingBetweenBeams = layoutProperties.beamSpacing;
  }
}

class BeamCanvasRenderBox extends RenderProxyBox {
  final List<StemBeamBoxes> _pairs = [];
  double beamThickness;
  double spacingBetweenBeams;

  BeamCanvasRenderBox({
    required this.beamThickness,
    required this.spacingBetweenBeams,
  });

  @override
  void performLayout() {
    _pairs.clear();

    // Recursively search for matching RenderBoxes
    _searchForBeamElementRenderBoxes(this);

    // Layout the child
    if (child != null) {
      child!.layout(constraints, parentUsesSize: true);
      size = child!.size;
    } else {
      size = Size.zero;
    }
  }

  void _searchForBeamElementRenderBoxes(RenderObject node) {
    // Check if the current RenderObject is a BeamElementRenderBox
    if (node is BeamElementRenderBox) {
      // Search for a specific descendant of this BeamElementRenderBox
      final BeamStemRenderBox? stem =
          _findSpecificDescendant<BeamStemRenderBox>(node);

      if (stem != null) {
        // Pair BeamElementRenderBox with its specific descendant
        _pairs.add((beam: node, stem: stem));

        // Stop further traversal for this branch
        return;
      }
    }

    // Recursively search single-child nodes
    if (node is RenderObjectWithChildMixin) {
      if (node.child != null) {
        _searchForBeamElementRenderBoxes(node.child!);
      }
    }

    // Recursively search multi-child nodes
    if (node is ContainerRenderObjectMixin) {
      node.visitChildren(_searchForBeamElementRenderBoxes);
    }
  }

  T? _findSpecificDescendant<T extends RenderObject>(RenderObject node) {
    T? foundChild;

    void search(RenderObject child) {
      if (foundChild != null) return; // Stop searching once found
      if (child is T) {
        foundChild = child; // Found a matching RenderObject of type T
      } else if (child is RenderObjectWithChildMixin) {
        if (child.child != null) search(child.child!);
      } else if (child is ContainerRenderObjectMixin) {
        child.visitChildren(search);
      }
    }

    if (node is RenderObjectWithChildMixin && node.child != null) {
      search(node.child!);
    } else if (node is ContainerRenderObjectMixin) {
      node.visitChildren(search);
    }

    return foundChild;
  }

  List<List<StemBeamBoxes>> get _patterns {
    return _pairs
        .splitAfter(
          (element) => element.beam.beams.firstOrNull?.value == BeamValue.end,
        )
        .toList();
  }

  Offset _positionInCanvas(RenderBox box) {
    // Get the global position of the StemWrapperRenderBox
    final Offset stemGlobalPosition = box.localToGlobal(Offset.zero);

    // Convert to local position relative to the current canvas
    return stemGlobalPosition - localToGlobal(Offset.zero);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);

    for (var pattern in _patterns) {
      var notesBeams = pattern.map((e) {
        Offset beamOffset = _positionInCanvas(e.stem) + offset;
        if (e.stem.direction == StemDirection.down) {
          beamOffset = beamOffset.translate(0, e.stem.size.height);
        }
        return NoteBeamData(
          beams: e.beam.beams,
          offset: beamOffset,
        );
      }).toList();

      var painter = BeamPainter(
        data: BeamGroupData.fromNotesBeams(notesBeams),
        flip: pattern.first.stem.direction == StemDirection.down,
        hookLength: 10,
        thickness: beamThickness,
        spacing: spacingBetweenBeams,
      );

      painter.paint(context.canvas, size);
    }
  }
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
