import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/time.dart';
import 'package:music_notation/src/models/elements/music_data/note/beam.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/notation_painter/notes/note_parts.dart';
import 'package:music_notation/src/notation_painter/notes/stemming.dart';
import 'package:music_notation/src/notation_painter/painters/beam_painter.dart';
import 'package:music_notation/src/notation_painter/properties/layout_properties.dart';
import 'package:music_notation/src/notation_painter/properties/notation_properties.dart';

/// Pair of a BeamElementRenderBox and its corresponding BeamStemRenderBox.
typedef StemBeamBoxes = ({BeamElementRenderBox beam, BeamStemRenderBox stem});

/// Beam data associated with a single musical note.
///
/// - [beams] - list of beams associated with the note.
/// - [offset] - position of the note on the canvas.
typedef NoteBeamData = ({List<Beam> beams, Offset offset});

/// The types of beams that can be drawn between notes.
enum BeamType {
  /// Beam connecting start and end points.
  full,

  /// Beam starting at a point and extending forward to a hook length.
  forwardHook,

  /// Beam starting at the end and extending backward to a hook length.
  backwardHook,
}

/// Represents a single beam segment connecting two widget beam points.
/// These two widgets are not necessarily adjacent elements in the layout.
/// Typically, one widget will be a note, and the beam point will correspond
/// to one endpoint of the note's stem.
class BeamSegment {
  /// The x-coordinate of the starting point of the beam segment.
  final double startX;

  /// The x-coordinate of the ending point of the beam segment.
  final double endX;

  /// The type of the beam segment (e.g., full, forwardHook, backwardHook).
  final BeamType type;

  /// Constructor to initialize a [BeamSegment].
  BeamSegment({
    required this.startX,
    required this.endX,
    required this.type,
  });
}

/// Represents a group of beams, organized by levels.
class BeamGroupPattern {
  /// Starting position of the group beam.
  final Offset start;

  /// Ending position of the bgroup beameam.
  final Offset end;

  /// A map where the key is the beam level, and the value is a list of [BeamGroupPattern].
  final Map<int, List<BeamSegment>> map;

  /// Constructor to initialize [BeamGroupPattern].
  BeamGroupPattern({
    required this.map,
    required this.start,
    required this.end,
  });

  /// Factory method to generate [BeamPattern] from a list of NoteBeamData.
  factory BeamGroupPattern.fromNotesBeams(Iterable<NoteBeamData> data) {
    // Tracks the last 'begin' positions (x value) for full beams.
    Map<int, double> lastBegin = {};

    final Map<int, List<BeamSegment>> map = {};
    for (var i = 0; i < data.length; i++) {
      var beams = data.elementAt(i).beams;
      var offset = data.elementAt(i).offset;
      Offset? maybeLastOffset;
      if (i > 0) {
        maybeLastOffset = data.elementAtOrNull(i - 1)?.offset;
      }
      Offset? maybeNextOffset = data.elementAtOrNull(i + 1)?.offset;

      // Filters the beams to include only unique beams based on their number.
      // Ensures no duplicate beam numbers exist, preventing redundant processing
      // of beams with the same number. The first beam encountered with a given
      // number will be retained, and subsequent beams with the same number
      // will be ignored.
      var uniqueBeams = SplayTreeSet<Beam>.of(
        beams,
        (a, b) => a.number.compareTo(b.number),
      );

      for (var beam in uniqueBeams) {
        // Process beam value types.
        switch (beam.value) {
          case BeamValue.begin:
            lastBegin[beam.number] = offset.dx;
            break;
          case BeamValue.end:
            if (lastBegin[beam.number] != null) {
              map[beam.number] ??= [];
              map[beam.number]?.add(BeamSegment(
                startX: lastBegin[beam.number]!,
                endX: offset.dx,
                type: BeamType.full,
              ));
            }
            lastBegin.remove(beam.number);
            break;
          case BeamValue.bContinue:
            break;
          case BeamValue.forwardHook:
            if (maybeNextOffset != null) {
              map[beam.number] ??= [];
              map[beam.number]?.add(BeamSegment(
                startX: offset.dx,
                endX: maybeNextOffset.dx,
                type: BeamType.forwardHook,
              ));
            }

            break;
          case BeamValue.backwardHook:
            if (maybeLastOffset != null) {
              map[beam.number] ??= [];
              map[beam.number]?.add(BeamSegment(
                startX: maybeLastOffset.dx,
                endX: offset.dx,
                type: BeamType.backwardHook,
              ));
            }
            break;
        }
      }
    }

    Offset start = data.firstOrNull?.offset ?? Offset.zero;
    Offset end = data.lastOrNull?.offset ?? start;

    return BeamGroupPattern(
      start: start,
      end: end,
      map: map,
    );
  }
}

/// Widget representing a beam element in the layout.
class BeamElement extends SingleChildRenderObjectWidget {
  /// List of beams managed by this element.
  final List<Beam> beams;

  /// Constructor for BeamElement.
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

/// Render box for the BeamElement widget.
class BeamElementRenderBox extends RenderProxyBox {
  /// List of beams being rendered.
  List<Beam> beams;

  /// Constructor to initialize BeamElementRenderBox.
  BeamElementRenderBox({required this.beams});

  @override
  void performLayout() {
    // Layout the child with loosened constraints.
    if (child != null) {
      child!.layout(constraints.loosen(), parentUsesSize: true);
    }

    // Set the size of the render box based on the child or a default size.
    size = constraints.constrain(Size(
      child?.size.width ?? 0,
      child?.size.height ?? 0,
    ));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // Paint the child, if available.
    if (child != null) {
      context.paintChild(child!, offset);
    }
  }
}

/// Canvas for rendering beams and associated elements.
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

/// Render box for managing and rendering beam groups on the canvas.
class BeamCanvasRenderBox extends RenderProxyBox {
  /// List of beam-stem pairs detected during layout.
  final List<StemBeamBoxes> _pairs = [];

  /// Thickness of the beams to be rendered.
  double beamThickness;

  /// Spacing between consecutive beams.
  double spacingBetweenBeams;

  /// Constructor to initialize BeamCanvasRenderBox.
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

  /// Recursively searches for BeamElementRenderBoxes and pairs them with their corresponding stems.
  void _searchForBeamElementRenderBoxes(RenderObject node) {
    // Check if the current node is a BeamElementRenderBox.
    if (node is BeamElementRenderBox) {
      final BeamStemRenderBox? stem =
          _findSpecificDescendant<BeamStemRenderBox>(node);

      if (stem != null) {
        _pairs.add((beam: node, stem: stem));
        return; // Stop traversal for this branch.
      }
    }

    // Recursively search child nodes for matches.
    if (node is RenderObjectWithChildMixin && node.child != null) {
      _searchForBeamElementRenderBoxes(node.child!);
    } else if (node is ContainerRenderObjectMixin) {
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
        return (beams: e.beam.beams, offset: beamOffset);
      });

      var painter = BeamPainter(
        pattern: BeamGroupPattern.fromNotesBeams(notesBeams),
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
