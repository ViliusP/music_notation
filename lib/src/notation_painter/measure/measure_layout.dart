import 'dart:math';

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
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/models/elements/score/part.dart';
import 'package:music_notation/src/notation_painter/notes/beaming.dart';
import 'package:music_notation/src/notation_painter/clef_element.dart';
import 'package:music_notation/src/notation_painter/notes/chord_element.dart';
import 'package:music_notation/src/notation_painter/cursor_element.dart';
import 'package:music_notation/src/notation_painter/debug/debug_settings.dart';
import 'package:music_notation/src/notation_painter/debug/stave_space_indicator_painter.dart';
import 'package:music_notation/src/notation_painter/key_element.dart';
import 'package:music_notation/src/notation_painter/measure/barline_painting.dart';
import 'package:music_notation/src/notation_painter/measure/inherited_padding.dart';
import 'package:music_notation/src/notation_painter/measure/measure_element.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/models/notation_context.dart';
import 'package:music_notation/src/notation_painter/notation_layout_properties.dart';
import 'package:music_notation/src/notation_painter/notes/note_element.dart';
import 'package:music_notation/src/notation_painter/notes/rest_element.dart';
import 'package:music_notation/src/notation_painter/notes/rhythmic_element.dart';
import 'package:music_notation/src/notation_painter/painters/barline_painter.dart';
import 'package:music_notation/src/notation_painter/painters/staff_lines_painter.dart';
import 'package:music_notation/src/notation_painter/spacing/timeline.dart';
import 'package:music_notation/src/notation_painter/time_beat_element.dart';
import 'package:music_notation/src/smufl/font_metadata.dart';

/// A widget that lays out musical measures with notes, chords, beams, and staff lines.
class MeasureLayout extends StatelessWidget {
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
        case RhythmicElement _:
          contextAfter = contextAfter.copyWith(
            divisions: measureElement.notationContext.divisions,
          );
          break;
        case TimeBeatElement _:
          contextAfter = contextAfter.copyWith(
            time: measureElement.timeBeat,
          );
        case KeySignatureElement _:
          contextAfter = contextAfter.copyWith(
            lastKey: measureElement.musicKey,
          );
          break;
      }
    }
    return contextAfter;
  }

  double? get _cachedWidth => _initialSpacings?.last;

  EdgeInsets get verticalPadding {
    return _calculateVerticalPadding();
  }

  final List<double>? _initialSpacings;

  final int? staff;
  final String? number;

  final BarlineSettings barlineSettings;

  final FontMetadata font;

  const MeasureLayout._({
    super.key,
    required this.children,
    required this.font,
    required List<double> initialSpacings,
    required this.notationContext,
    this.useExplicitBeaming = false,
    this.staff,
    this.number,
    this.barlineSettings = const BarlineSettings(),
  }) : _initialSpacings = initialSpacings;

  factory MeasureLayout.fromMeasureData({
    Key? key,
    required Measure measure,
    required FontMetadata font,
    int? staff,
    required NotationContext notationContext,
    bool useExplicitBeaming = false,
    BarlineSettings barlineSettings = const BarlineSettings(),
  }) {
    var children = _computeChildren(
      context: notationContext,
      measure: measure,
      font: font,
      staff: staff,
    );
    var spacings = _computeSpacings(children);

    return MeasureLayout._(
      key: key,
      initialSpacings: spacings,
      font: font,
      notationContext: notationContext,
      useExplicitBeaming: useExplicitBeaming,
      staff: staff,
      number: measure.attributes.number,
      barlineSettings: barlineSettings,
      children: children,
    );
  }

  /// Processes a note and determines if it should be rendered as a single note or part of a chord.
  static MeasureWidget? _processNote(
    Note note,
    NotationContext context,
    List<MusicDataElement> measureData,
    FontMetadata font,
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
        font: font,
      );
    }

    if (note.form is Rest) {
      return RestElement.fromNote(
        note: note,
        context: context,
        font: font,
      );
    }
    return NoteElement.fromNote(
      note: note,
      notationContext: context,
      font: font,
    );
  }

  static List<MeasureWidget> _processAttributes(
    Attributes element,
    int? staff,
    NotationContext notationContext,
    FontMetadata font,
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
      widgets.add(ClefElement(clef: clef, font: font));
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
    var keySignature = KeySignatureElement.fromKeyData(
      keyData: musicKey,
      notationContext: notationContext,
      font: font,
    );
    if (keySignature.accidentals.isNotEmpty) {
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
    Clef? clef = element.clefs.firstWhereOrNull(
      (element) => staff != null ? element.number == staff : true,
    );

    return notationContext.copyWith(
      clef: clef,
      time: element.times.firstOrNull,
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
    required FontMetadata font,
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
            font,
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
          // TODO: test attributes parsing and context change.
          // For example, time beat mid score change should be seen in new context.
          var attributesWidgets = _processAttributes(
            element,
            staff,
            contextAfter,
            font,
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
      if (child is RhythmicElement) {
        divisions = child.notationContext.divisions!;
        break;
      }
    }

    final Timeline timeline = Timeline(divisions: divisions)..compute(children);
    return timeline.toSpacings(NotationLayoutProperties.staveHeight * 1.5);
  }

// Calculate the vertical padding based on the highest note above and below the staff.
  EdgeInsets _calculateVerticalPadding() {
    double topPadding = 0;
    double bottomPadding = 0;

    for (var child in children) {
      topPadding = max(topPadding, child.boxAboveStaff().height);
      bottomPadding = max(bottomPadding, child.boxBelowStaff().height);
    }

    return EdgeInsets.only(
      bottom: bottomPadding,
      top: topPadding,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<double> spacings = _initialSpacings!;

    const offsetPerPosition = NotationLayoutProperties.staveSpace / 2;

    double width = _cachedWidth ?? spacings.last;

    final inheritedPadding = InheritedPadding.of(context);
    if (inheritedPadding == null) return SizedBox.shrink();

    DebugSettings? dSettings = DebugSettings.of(context);

    return LayoutBuilder(builder: (context, constraints) {
      List<Widget> beamGroups = [];

      BeamGrouping beaming = BeamGrouping();

      var positionedElements = <Widget>[];
      for (var (index, child) in children.indexed) {
        BeamingResult? beamingResult;
        if (child is RhythmicElement) {
          beamingResult = beaming.add(child, spacings[index]);
        }

        if (beaming.isFinalized) {
          beamGroups.add(
            Positioned.fill(child: BeamGroup.fromBeaming(beaming)),
          );
          beaming = BeamGrouping();
        }

        double? topOffset;
        double? bottomOffset;

        if (child.alignmentPosition.top != null) {
          topOffset = child.alignmentPosition.top!;

          // Calculate the interval from staff top to the child's position.
          int intervalFromTheF5 = ElementPosition.staffTop.numeric;
          intervalFromTheF5 -= child.position.numeric;
          topOffset += intervalFromTheF5 * offsetPerPosition;

          topOffset += inheritedPadding.top;
        }
        if (child.alignmentPosition.bottom != null) {
          bottomOffset = 0;
          bottomOffset = child.alignmentPosition.bottom ?? 0;

          // Calculate the interval from staff bottom to the child's position.
          int intervalFromTheE4 = ElementPosition.staffBottom.numeric;
          intervalFromTheE4 -= child.position.numeric;
          bottomOffset -= intervalFromTheE4 * offsetPerPosition;

          bottomOffset += inheritedPadding.bottom;
        }

        if (beamingResult == null || beamingResult == BeamingResult.skipped) {
          positionedElements.add(
            Positioned(
              left: spacings[index],
              top: topOffset,
              bottom: bottomOffset,
              child: child,
            ),
          );
        }

        if (dSettings != null) {
          Rect boxBelow = child.boxBelowStaff();
          if (dSettings.paintBBoxBelowStaff && boxBelow.height > 0) {
            positionedElements.add(
              Positioned(
                left: spacings[index],
                top:
                    inheritedPadding.top + NotationLayoutProperties.staveHeight,
                child: Container(
                  width: boxBelow.width,
                  height: [boxBelow.height, 0].max.toDouble(),
                  color: Color.fromRGBO(255, 10, 100, 0.2),
                ),
              ),
            );
          }

          Rect boxAbove = child.boxAboveStaff();
          if (dSettings.paintBBoxAboveStaff && boxAbove.height > 0) {
            positionedElements.add(
              Positioned(
                left: spacings[index],
                bottom: inheritedPadding.bottom +
                    NotationLayoutProperties.staveHeight,
                child: Container(
                  width: boxAbove.width,
                  height: [boxAbove.height, 0].max.toDouble(),
                  color: Color.fromRGBO(3, 154, 255, 0.2),
                ),
              ),
            );
          }
        }
      }

      EdgeInsets measurePadding = EdgeInsets.only(
        top: inheritedPadding.top,
        bottom: inheritedPadding.bottom,
      );

      return Stack(
        fit: StackFit.loose,
        children: [
          Padding(
            padding: measurePadding,
            child: SizedBox.fromSize(
              size: Size(
                constraints.maxWidth.isFinite ? constraints.maxWidth : width,
                NotationLayoutProperties.staveHeight,
              ),
              child: StaffLines(
                startExtension: barlineSettings.startExtension,
                endExtension: barlineSettings.endExtension,
                measurePadding: measurePadding,
              ),
            ),
          ),
          if (dSettings?.beatGuideType != null)
            CustomPaint(
              size: Size(
                constraints.maxWidth.isFinite ? constraints.maxWidth : width,
                NotationLayoutProperties.staveHeight,
              ),
              painter: BeatMarkPainter(dSettings!.beatGuideType!, 0),
          ),
          ...beamGroups,
          ...positionedElements,
        ],
      );
    });
  }
}

class StaffLines extends StatelessWidget {
  final BarlineExtension startExtension;
  final BarlineExtension endExtension;
  final EdgeInsets measurePadding;

  const StaffLines({
    super.key,
    required this.startExtension,
    required this.endExtension,
    required this.measurePadding,
  });

  @override
  Widget build(BuildContext context) {
    // Map<BarlineExtension, Color> colors = {
    //   BarlineExtension.both: Color.fromRGBO(27, 114, 0, .5),
    //   BarlineExtension.bottom: Color.fromRGBO(255, 0, 0, .5),
    //   BarlineExtension.none: Color.fromRGBO(195, 0, 255, .5),
    //   BarlineExtension.top: Color.fromRGBO(4, 0, 255, .5),
    // };

    double calculatedStartOffset = 0;
    double calculatedStartHeight = BarlinePainter.size.height;
    if (startExtension == BarlineExtension.bottom) {
      calculatedStartHeight += measurePadding.bottom;
    }

    if (startExtension == BarlineExtension.both) {
      calculatedStartHeight += measurePadding.bottom;
      calculatedStartOffset -= measurePadding.top;
    }

    if (startExtension == BarlineExtension.top) {
      calculatedStartOffset -= measurePadding.top;
    }

    double calculatedEndOffset = 0;
    double calculatedEndHeight = BarlinePainter.size.height;
    if (endExtension == BarlineExtension.bottom) {
      calculatedEndHeight += measurePadding.bottom;
    }

    if (endExtension == BarlineExtension.both) {
      calculatedEndHeight += measurePadding.bottom;
      calculatedEndOffset -= measurePadding.top;
    }

    if (endExtension == BarlineExtension.top) {
      calculatedEndOffset -= measurePadding.top;
    }

    DebugSettings? debugSettings = DebugSettings.of(context);

    return Stack(
      fit: StackFit.expand,
      children: [
        if (startExtension != BarlineExtension.none)
          Align(
            alignment: Alignment.centerLeft,
            child: CustomPaint(
              size: Size.fromWidth(BarlinePainter.size.width),
              painter: BarlinePainter(
                // color: colors[startExtension]!,
                offset: calculatedStartOffset,
                height: calculatedStartHeight,
                end: false,
              ),
            ),
          ),
        CustomPaint(
          painter: StaffLinesPainter(
            extraStaveLineCount: debugSettings?.extraStaveLineCount ?? 0,
            extraStaveLines:
                debugSettings?.extraStaveLines ?? ExtraStaveLines.none,
          ),
        ),
        if ((debugSettings?.verticalStaveLineSpacingMultiplier ?? 0) != 0)
          CustomPaint(
            painter: StaveSpaceIndicatorPainter(
              debugSettings?.verticalStaveLineSpacingMultiplier ?? 0,
            ),
          ),
        Align(
          alignment: Alignment.centerRight,
          child: CustomPaint(
            size: Size.fromWidth(BarlinePainter.size.width),
            painter: BarlinePainter(
              // color: colors[endExtension]!,
              offset: calculatedEndOffset,
              height: calculatedEndHeight,
            ),
          ),
        ),
      ],
    );
  }
}
