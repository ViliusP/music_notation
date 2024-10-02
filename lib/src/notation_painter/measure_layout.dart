import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

import 'package:music_notation/src/models/elements/music_data/attributes/attributes.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/clef.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/key.dart'
    as musicxml show Key;

import 'package:music_notation/src/models/elements/music_data/attributes/time.dart';
import 'package:music_notation/src/models/elements/music_data/backup.dart';
import 'package:music_notation/src/models/elements/music_data/direction/direction.dart';
import 'package:music_notation/src/models/elements/music_data/forward.dart';
import 'package:music_notation/src/models/elements/music_data/music_data.dart';
import 'package:music_notation/src/models/elements/music_data/note/beam.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/models/elements/score/part.dart';
import 'package:music_notation/src/notation_painter/attributes_elements.dart';
import 'package:music_notation/src/notation_painter/cursor_element.dart';
import 'package:music_notation/src/notation_painter/key_element.dart';
import 'package:music_notation/src/notation_painter/measure_element.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/models/notation_context.dart';
import 'package:music_notation/src/notation_painter/notation_layout_properties.dart';
import 'package:music_notation/src/notation_painter/note_element.dart';
import 'package:music_notation/src/notation_painter/painters/barline_painter.dart';
import 'package:music_notation/src/notation_painter/painters/beam_painter.dart';
import 'package:music_notation/src/notation_painter/painters/staff_lines_painter.dart';
import 'package:music_notation/src/notation_painter/spacing/timeline.dart';
import 'package:music_notation/src/notation_painter/time_beat_element.dart';

/// A widget that lays out musical measures with notes, chords, beams, and staff lines.
class MeasureLayout extends StatelessWidget {
  static const double _minPositionPadding = 4;

  /// Determines if the music notation renderer should use specified beaming
  /// directly from the musicXML file.
  ///
  /// By default, the renderer will rely on the beaming data as it is
  /// directly provided in the musicXML file, without making any changes or
  /// assumptions.
  ///
  /// Set this property to `false` if the score contains raw or incomplete
  /// musicXML data, allowing the renderer to determine beaming based on its
  /// internal logic or algorithms.
  final bool useExplicitBeaming;

  final List<MeasureWidget> children;

  final NotationContext notationContext;
  NotationContext get contextAfter {
    NotationContext contextAfter = notationContext.copyWith();
    for (var measureElement in children) {
      switch (measureElement) {
        case ClefElement clefElement:
          contextAfter = contextAfter.copyWith(
            clef: clefElement.clef,
          );
          break;
        case NoteElement _:
          contextAfter = contextAfter.copyWith(
            divisions: measureElement.divisions,
          );
          break;
        case Chord _:
          contextAfter = contextAfter.copyWith(
            divisions: measureElement.divisions,
          );
          break;
        case TimeBeatElement _:
          contextAfter = contextAfter.copyWith(
            time: measureElement.timeBeat,
          );
          break;
      }
    }
    return contextAfter;
  }

  // final int? staff;
  double? get _cachedWidth => _initialSpacings?.last;
  double get _height {
    return 0;
  }

  final List<double>? _initialSpacings;

  const MeasureLayout._({
    super.key,
    required this.children,
    required List<double> initialSpacings,
    required this.notationContext,
    this.useExplicitBeaming = false,
  }) : _initialSpacings = initialSpacings;

  factory MeasureLayout.fromMeasureData({
    Key? key,
    required Measure measure,
    int? staff,
    required NotationContext notationContext,
    bool useExplicitBeaming = false,
  }) {
    var children = _computeChildren(
      context: notationContext,
      measure: measure,
      staff: staff,
    );
    var spacings = _computeSpacings(children);

    return MeasureLayout._(
      key: key,
      initialSpacings: spacings,
      notationContext: notationContext,
      useExplicitBeaming: useExplicitBeaming,
      children: children,
    );
  }

  /// Processes a note and determines if it should be rendered as a single note or part of a chord.
  static MeasureWidget? _processNote(
    Note note,
    NotationContext context,
    List<MusicDataElement> measureData,
    int? staff,
  ) {
    if (context.divisions == null) {
      throw ArgumentError(
        "Context or measure must have divisions in attributes element",
      );
    }
    if (staff != null && staff != note.staff) return null;

    List<Note> notes = [note];
    int i = 0;
    while (i < measureData.length) {
      var nextElement = measureData[i];
      if (nextElement is Note &&
          nextElement.chord != null &&
          (staff == null || staff == nextElement.staff)) {
        notes.add(nextElement);
        i++;
      } else {
        break;
      }
    }
    if (notes.length > 1) {
      return Chord.fromNotes(
        notes: notes,
        notationContext: context,
      );
    }
    return NoteElement.fromNote(
      note: note,
      notationContext: context,
    );
  }

  static List<MeasureWidget> _processAttributes(
    Attributes element,
    int? staff,
    NotationContext notationContext,
  ) {
    List<MeasureWidget> widgets = [];
    // -----------------------------
    // Clef
    // -----------------------------
    if (element.clefs.isNotEmpty) {
      // TODO: Implement handling for multiple clefs per staff.
      if (element.clefs.length > 1 && staff == null) {
        throw UnimplementedError(
          "Multiple clef signs are not implemented in renderer yet",
        );
      }

      Clef clef = element.clefs.firstWhere(
        (element) => staff != null ? element.number == staff : true,
      );

      notationContext = notationContext.copyWith(
        clef: clef,
        divisions: element.divisions,
      );
      widgets.add(ClefElement(clef: clef));
    }
    // -----------------------------
    // Keys
    // -----------------------------
    var keys = element.keys;
    if (keys.isEmpty) return widgets;
    musicxml.Key? musicKey;
    if (keys.length == 1 && keys.first.number == null) {
      musicKey = keys.first;
    }
    if (staff != null && keys.length > 1) {
      musicKey = keys.firstWhereOrNull(
        (element) => element.number == staff,
      );
    }
    if (musicKey == null) {
      throw ArgumentError(
        "There are multiple keys elements in attributes, therefore correct staff must be provided",
      );
    }
    var keySignature = KeySignature.fromKeyData(
      keyData: musicKey,
      notationContext: notationContext,
    );
    if (keySignature.firstPosition != null) {
      widgets.add(keySignature);
    }
    // -----------------------------
    // Time
    // -----------------------------

    for (var times in element.times) {
      switch (times) {
        case TimeBeat _:
          var timeBeatWidget = TimeBeatElement(timeBeat: times);
          widgets.add(timeBeatWidget);
          break;
        case SenzaMisura _:
          throw UnimplementedError(
            "Senza misura is not implemented in renderer yet",
          );
      }
    }
    return widgets;
  }

  static NotationContext _contextAfterAttributes(
    Attributes element,
    int? staff,
    NotationContext notationContext,
  ) {
    Clef clef = element.clefs.firstWhere(
      (element) => staff != null ? element.number == staff : true,
    );

    return notationContext.copyWith(
      clef: clef,
      divisions: element.divisions,
    );
  }

  /// Builds a list of [MeasureWidget]s based on the provided measure data and notation context.
  ///
  /// - [context]: The current notation context.
  /// - [staff]: The staff number to filter elements (optional).
  /// - [measure]: The measure data containing musical elements.
  ///
  /// Returns a list of [MeasureWidget]s representing the musical elements within the measure.
  static List<MeasureWidget> _computeChildren({
    required NotationContext context,
    required int? staff,
    required Measure measure,
  }) {
    NotationContext contextAfter = context.copyWith();

    final children = <MeasureWidget>[];
    for (int i = 0; i < measure.data.length; i++) {
      var element = measure.data[i];
      switch (element) {
        case Note note:
          var noteWidget = _processNote(
            note,
            contextAfter,
            measure.data.sublist(i + 1),
            staff,
          );
          if (noteWidget != null) {
            children.add(noteWidget);
          }
          if (noteWidget is Chord) {
            i += noteWidget.notes.length - 1;
          }
          break;
        case Backup backup:
          children.add(CursorElement(duration: -backup.duration));
          break;
        case Forward forward:
          children.add(CursorElement(
            duration: forward.duration,
            voice: forward.editorialVoice.voice,
            staff: forward.staff,
          ));
          break;
        case Direction _:
          break;
        case Attributes _:
          var attributesWidgets = _processAttributes(
            element,
            staff,
            contextAfter,
          );
          contextAfter = _contextAfterAttributes(element, staff, contextAfter);
          children.addAll(attributesWidgets);
          break;
        // case Harmony _:
        //   break;
        // case FiguredBass _:
        //   break;
        // case Print _:
        //   break;
        // case Sound _:
        //   break;
        // case Listening _:
        //   break;
        // case Barline _:
        //   break;
        // case Grouping _:
        //   break;
        // case Link _:
        //   break;
        // case Bookmark _:
        //   break;
      }
    }
    return children;
  }

  static List<double> _computeSpacings(
    List<MeasureWidget> children,
  ) {
    double divisions = 1;
    for (var child in children.reversed) {
      if (child is NoteElement) {
        divisions = child.divisions;
        break;
      }
      if (child is Chord) {
        divisions = child.divisions;
        break;
      }
    }

    final Timeline timeline = Timeline(divisions: divisions)..compute(children);
    return timeline.toList(54);
  }

  // Calculate the vertical padding based on the highest note above and below the staff.
  double _calculateVerticalPadding() {
    const offsetPerPosition = NotationLayoutProperties.staveSpace / 2;

    double distanceToStaffTop =
        offsetPerPosition * ElementPosition.staffTop.numeric;
    double distanceToStaffBottom =
        offsetPerPosition * ElementPosition.staffBottom.numeric;

    double topPadding = 0;
    double bottomPadding = 0;

    for (var child in children) {
      double aboveStaffLength = [
        offsetPerPosition * child.position.numeric,
        child.size.height,
        child.positionalOffset,
        -distanceToStaffTop
      ].sum;

      aboveStaffLength = [0.0, aboveStaffLength].max;

      double belowStaffLength = [
        offsetPerPosition * child.position.numeric,
        child.positionalOffset,
        -distanceToStaffBottom,
      ].sum;

      belowStaffLength = [0.0, belowStaffLength].min.abs();

      if (topPadding < aboveStaffLength) {
        topPadding = aboveStaffLength;
      }
      if (bottomPadding < belowStaffLength) {
        bottomPadding = belowStaffLength;
      }
    }

    double verticalPadding = [bottomPadding, topPadding].max;
    verticalPadding += NotationLayoutProperties.staffLineStrokeWidth / 2;

    return verticalPadding;
  }

  @override
  Widget build(BuildContext context) {
    List<double> spacings = _initialSpacings!;

    const offsetPerPosition = NotationLayoutProperties.staveSpace / 2;
    double verticalPadding = _calculateVerticalPadding();

    List<Widget> beams = [];
    (double x, double y)? beamStartOffset;
    (double x, double y)? beamEndOffset;

    var positionedElements = <Widget>[];
    for (var (index, child) in children.indexed) {
      // Calculate bottomOffset for the current child.
      double bottomOffset = verticalPadding;

      // Calculate the interval from staff bottom to the child's position.
      int intervalFromStaffBottom = ElementPosition.staffBottom.numeric;
      intervalFromStaffBottom -= child.position.numeric + 1;
      bottomOffset -= (intervalFromStaffBottom * offsetPerPosition);

      // Adjust by the child's positional offset.
      bottomOffset += child.positionalOffset;

      // Process beam for the current child
      var beamResult = BeamProcessingResult.processBeam(
        child: child,
        index: index,
        bottomOffset: bottomOffset,
        spacings: spacings,
        beamStartOffset: beamStartOffset,
        beamEndOffset: beamEndOffset,
      );

      // Update beam offsets and beams if necessary
      beamStartOffset = beamResult.beamStartOffset;
      beamEndOffset = beamResult.beamEndOffset;
      if (beamResult.beamWidget != null) {
        beams.add(beamResult.beamWidget!);
        // Reset the beam offsets
        beamStartOffset = null;
        beamEndOffset = null;
      }

      // Add the positioned child to the list.
      positionedElements.add(
        Positioned(
          left: spacings[index],
          bottom: bottomOffset,
          child: child,
        ),
      );
    }

    double width = _cachedWidth ?? spacings.last;

    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        fit: StackFit.loose,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: verticalPadding),
            child: SizedBox.fromSize(
              size: Size(
                constraints.maxWidth.isFinite ? constraints.maxWidth : width,
                NotationLayoutProperties.staveHeight,
              ),
              child: const StaffLines(),
            ),
          ),
          ...beams,
          ...positionedElements,
        ],
      );
    });
  }
}

class StaffLines extends StatelessWidget {
  final bool hasStartBarline;
  final bool hasEndBarline;

  const StaffLines({
    super.key,
    this.hasStartBarline = false,
    this.hasEndBarline = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (hasStartBarline)
          Align(
            alignment: Alignment.centerLeft,
            child: CustomPaint(
              size: BarlinePainter.size,
              painter: BarlinePainter(),
            ),
          ),
        CustomPaint(
          painter: StaffLinesPainter(),
        ),
        if (hasEndBarline)
          Align(
            alignment: Alignment.centerRight,
            child: CustomPaint(
              size: BarlinePainter.size,
              painter: BarlinePainter(),
            ),
          ),
      ],
    );
  }
}

class BeamProcessingResult {
  final (double x, double y)? beamStartOffset;
  final (double x, double y)? beamEndOffset;
  final Widget? beamWidget;

  BeamProcessingResult({
    this.beamStartOffset,
    this.beamEndOffset,
    this.beamWidget,
  });

  static BeamProcessingResult processBeam({
    required MeasureWidget child,
    required int index,
    required double bottomOffset,
    required List<double> spacings,
    (double x, double y)? beamStartOffset,
    (double x, double y)? beamEndOffset,
  }) {
    bool isBeamStart = false;
    bool isBeamEnd = false;
    double? offsetX;
    double? offsetY;

    // Check if the child has an offsetForBeam property
    if (child is NoteElement) {
      var beamValue = child.note.beams.firstOrNull?.value;
      if (beamValue != null) {
        isBeamStart = beamValue == BeamValue.begin;
        isBeamEnd = beamValue == BeamValue.end;
      }
      offsetX = child.offsetForBeam.dx;
      offsetY = child.offsetForBeam.dy;
    } else if (child is Chord) {
      var beamsList = child.notes.expand((note) => note.beams);
      isBeamStart = beamsList.any((beam) => beam.value == BeamValue.begin);
      isBeamEnd = beamsList.any((beam) => beam.value == BeamValue.end);
      offsetX = child.offsetForBeam.dx;
      offsetY = child.offsetForBeam.dy;
    }

    // Update beam offsets
    if (isBeamStart && offsetX != null && offsetY != null) {
      beamStartOffset = (
        offsetX +
            spacings[index] -
            NotationLayoutProperties.stemStrokeWidth * 0.5,
        bottomOffset + offsetY,
      );
    }

    if (isBeamEnd && offsetX != null && offsetY != null) {
      beamEndOffset = (
        offsetX +
            spacings[index] +
            NotationLayoutProperties.stemStrokeWidth * 0.5,
        bottomOffset + offsetY,
      );
    }

    // If both beam offsets are defined, create the beam widget
    if (beamStartOffset != null && beamEndOffset != null) {
      Widget beamWidget = Positioned(
        left: beamStartOffset.$1,
        bottom: beamStartOffset.$2,
        child: CustomPaint(
          painter: BeamPainter(
            secondPoint: Offset(
              beamEndOffset.$1 - beamStartOffset.$1,
              beamStartOffset.$2 - beamEndOffset.$2,
            ),
          ),
        ),
      );
      return BeamProcessingResult(
        beamWidget: beamWidget,
      );
    }

    return BeamProcessingResult(
      beamStartOffset: beamStartOffset,
      beamEndOffset: beamEndOffset,
    );
  }
}
