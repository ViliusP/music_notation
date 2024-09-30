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
import 'package:music_notation/src/notation_painter/key_element.dart';
import 'package:music_notation/src/notation_painter/measure_element.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/models/notation_context.dart';
import 'package:music_notation/src/notation_painter/notation_layout_properties.dart';
import 'package:music_notation/src/notation_painter/note_element.dart';
import 'package:music_notation/src/notation_painter/painters/barline_painter.dart';
import 'package:music_notation/src/notation_painter/painters/beam_painter.dart';
import 'package:music_notation/src/notation_painter/painters/staff_lines_painter.dart';
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
        case ClefElement _:
          contextAfter = contextAfter.copyWith(
            clef: measureElement.clef,
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
    if (staff != note.staff && staff != null) return null;
    List<Note> notes = [];
    notes.add(note);
    for (int i = 0; i < measureData.length; i++) {
      var nextElement = measureData[i];
      if (nextElement is! Note || nextElement.chord == null) {
        break;
      }
      if (staff == nextElement.staff || staff == null) {
        notes.add(nextElement);
        continue;
      }
      break;
    }
    if (notes.length == 1) {
      return NoteElement.fromNote(
        note: note,
        notationContext: context,
      );
    }
    if (notes.length > 1) {
      return Chord.fromNotes(
        notes: notes,
        notationContext: context,
      );
    }
    return null;
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
          "Multiple clef signs is not implemented in renderer yet",
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
        case Backup _:
          break;
        case Forward _:
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

  static List<double> _computeSpacings(List<MeasureWidget> children) {
    const double horizontalPadding = 8.0;
    const double spacingBetweenElements = 8.0;

    final List<double> childSpacings = [];

    // Collect all voices from the children.
    final Set<String> voices = {
      for (final child in children)
        if (child is NoteElement)
          child.note.editorialVoice.voice ?? "1"
        else if (child is Chord)
          child.notes.firstOrNull?.editorialVoice.voice ?? "1"
    };

    // Ensure there is at least one voice.
    if (voices.isEmpty) {
      voices.add("1");
    }

    // Add "0" for generic elements.
    voices.add("0");

    // Initialize spacings and sizes for each voice.
    final Map<String, List<double>> spacingsByVoice = {
      for (var voice in voices) voice: []
    };

    final Map<String, Size> lastElementSizeByVoice = {
      for (var voice in voices) voice: Size.zero
    };

    // Helper function to process NoteElement or Chord.
    void processNoteOrChord(MeasureWidget child, String voice) {
      // Calculate the starting horizontal offset.
      double startingOffset = [
        horizontalPadding,
        (spacingsByVoice["0"]!.lastOrNull ?? 0),
        lastElementSizeByVoice["0"]!.width,
        spacingBetweenElements
      ].sum;

      double noteLeftOffset =
          spacingsByVoice[voice]!.lastOrNull ?? startingOffset;

      if (spacingsByVoice[voice]!.isNotEmpty) {
        noteLeftOffset += spacingBetweenElements;
        noteLeftOffset += lastElementSizeByVoice[voice]!.width;
      }

      spacingsByVoice[voice]!.add(noteLeftOffset);
      childSpacings.add(noteLeftOffset);

      lastElementSizeByVoice[voice] = child.size;
    }

    for (var child in children) {
      if (child is NoteElement) {
        String voice = child.note.editorialVoice.voice ?? "1";
        processNoteOrChord(child, voice);
        continue;
      }
      if (child is Chord) {
        String voice = child.notes.firstOrNull?.editorialVoice.voice ?? "1";
        processNoteOrChord(child, voice);
        continue;
      }
      // Non-note elements.
      double leftOffset = [
        childSpacings.lastOrNull ?? horizontalPadding,
        spacingBetweenElements,
        lastElementSizeByVoice["0"]!.width,
      ].sum;

      childSpacings.add(leftOffset);

      spacingsByVoice["0"]!.add(leftOffset);
      lastElementSizeByVoice["0"] = child.size;
    }

    // Add final spacing.
    final double maxSpacing = childSpacings.isNotEmpty
        ? childSpacings.reduce((a, b) => a > b ? a : b)
        : 0.0;
    final int maxIndex = childSpacings.indexOf(maxSpacing);
    final double lastChildWidth = children[maxIndex].size.width;

    childSpacings.add(maxSpacing + lastChildWidth + horizontalPadding);

    return childSpacings;
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
      double aboveStaffLength = offsetPerPosition * child.position.numeric +
          child.size.height +
          child.positionalOffset -
          distanceToStaffTop;
      aboveStaffLength = [0.0, aboveStaffLength].max;

      double belowStaffLength = offsetPerPosition * child.position.numeric +
          child.positionalOffset -
          distanceToStaffBottom;
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
      // Firstly move element's bottom to staff bottom.
      double bottomOffset = verticalPadding;

      // Then move it by interval.
      int intervalFromStaffBottom = ElementPosition.staffBottom.numeric;
      intervalFromStaffBottom -= child.position.numeric + 1;
      bottomOffset -= (intervalFromStaffBottom * offsetPerPosition);

      // Lastly adjust to it's by positional offset.
      bottomOffset += child.positionalOffset;

      if (child is Chord &&
          child.notes
              .map((e) => e.beams)
              .flattened
              .any((element) => element.value == BeamValue.begin)) {
        beamStartOffset = (
          child.offsetForBeam.dx +
              spacings[index] -
              NotationLayoutProperties.stemStrokeWidth * 0.5,
          bottomOffset + child.offsetForBeam.dy,
        );
      }
      if (child is Chord &&
          child.notes
              .map((e) => e.beams)
              .flattened
              .any((element) => element.value == BeamValue.end)) {
        beamEndOffset = (
          child.offsetForBeam.dx +
              spacings[index] +
              NotationLayoutProperties.stemStrokeWidth * 0.5,
          bottomOffset + child.offsetForBeam.dy,
        );
      }

      if (child is NoteElement &&
          child.note.beams.firstOrNull?.value == BeamValue.begin) {
        beamStartOffset = (
          child.offsetForBeam.dx +
              spacings[index] -
              NotationLayoutProperties.stemStrokeWidth * 0.5,
          bottomOffset + child.offsetForBeam.dy,
        );
      }

      if (child is NoteElement &&
          child.note.beams.firstOrNull?.value == BeamValue.end) {
        beamEndOffset = (
          [
            child.offsetForBeam.dx,
            spacings[index],
            NotationLayoutProperties.stemStrokeWidth * 0.5
          ].sum,
          bottomOffset + child.offsetForBeam.dy,
        );
      }

      if (beamStartOffset != null && beamEndOffset != null) {
        beams.add(
          Positioned(
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
          ),
        );

        beamStartOffset = null;
        beamEndOffset = null;
      }

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
