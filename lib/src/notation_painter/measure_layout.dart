import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:music_notation/src/models/data_types/step.dart';

import 'package:music_notation/src/models/elements/music_data/attributes/attributes.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/clef.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/key.dart'
    as musicxml show Key;

import 'package:music_notation/src/models/elements/music_data/attributes/time.dart';
import 'package:music_notation/src/models/elements/music_data/backup.dart';
import 'package:music_notation/src/models/elements/music_data/direction/direction.dart';
import 'package:music_notation/src/models/elements/music_data/forward.dart';
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
import 'package:music_notation/src/notation_painter/painters/staff_lines_painter.dart';
import 'package:music_notation/src/notation_painter/time_beat_element.dart';

class MeasureLayout extends StatelessWidget {
  static const double _minPositionPadding = 4;

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
  }) : _initialSpacings = initialSpacings;

  factory MeasureLayout.fromMeasureData({
    Key? key,
    required Measure measure,
    int? staff,
    required NotationContext notationContext,
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
      children: children,
    );
  }

  static List<MeasureWidget> _computeChildren({
    required NotationContext context,
    required int? staff,
    required Measure measure,
  }) {
    NotationContext contextAfter = context.copyWith();

    final children = <MeasureWidget>[];
    int i = 0;
    while (i < measure.data.length) {
      var element = measure.data[i];
      switch (element) {
        case Note _:
          if (contextAfter.divisions == null) {
            throw ArgumentError(
              "Context or measure must have divisions in attributes element",
            );
          }

          if (staff == element.staff || staff == null) {
            List<Note> notes = [];
            notes.add(element);
            int j = i + 1;
            for (; j < measure.data.length; j++) {
              var nextElement = measure.data[j];
              if (nextElement is! Note || nextElement.chord == null) {
                break;
              }
              if (staff == nextElement.staff || staff == null) {
                notes.add(nextElement);
                continue;
              }
              break;
            }
            i = j - 1;
            if (notes.length == 1) {
              var noteElement = NoteElement.fromNote(
                note: element,
                notationContext: contextAfter,
              );

              children.add(noteElement);
            }
            if (notes.length > 1) {
              var chordElement = Chord.fromNotes(
                notes: notes,
                notationContext: contextAfter,
              );

              children.add(chordElement);
            }
          }
          break;

        case Backup _:
          break;
        case Forward _:
          break;
        case Direction _:
          break;
        case Attributes _:
          // -----------------------------
          // Clef
          // -----------------------------
          if (element.clefs.isNotEmpty) {
            if (element.clefs.length > 1 && staff == null) {
              throw UnimplementedError(
                "Multiple clef signs is not implemented in renderer yet",
              );
            }

            Clef clef = element.clefs.firstWhere(
              (element) => staff != null ? element.number == staff : true,
            );

            contextAfter = contextAfter.copyWith(
              clef: clef,
              divisions: element.divisions,
            );
            children.add(ClefElement(clef: clef));
          }
          // -----------------------------
          // Time
          // -----------------------------

          for (var times in element.times) {
            switch (times) {
              case TimeBeat _:
                var timeBeatWidget = TimeBeatElement(timeBeat: times);
                children.add(timeBeatWidget);
                break;
              case SenzaMisura _:
                throw UnimplementedError(
                  "Senza misura is not implemented in renderer yet",
                );
            }
          }
          // -----------------------------
          // Keys
          // -----------------------------
          var keys = element.keys;
          if (keys.isEmpty) break;
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
            notationContext: contextAfter,
          );
          if (keySignature.firstPosition != null) {
            children.add(keySignature);
          }
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
      i++;
    }
    return children;
  }

  /// Returns initial list of spacings that do not consider [measure]'s stretching
  /// and compression.
  static List<double> _computeSpacings(List<MeasureWidget> children) {
    const horizontalPadding = 8.0;
    double leftOffset = horizontalPadding;
    // Will be change in future.
    const spacingBetweenElements = 8;
    double lastElementWidth = 0;

    final List<double> spacings = [];

    for (var child in children) {
      spacings.add(leftOffset);
      lastElementWidth = child.size.width;
      leftOffset += spacingBetweenElements + child.size.width;
    }

    spacings.add(leftOffset + horizontalPadding + lastElementWidth);
    return spacings;
  }

  @override
  Widget build(BuildContext context) {
    const offsetPerPosition = NotationLayoutProperties.staveSpace / 2;

    List<double> spacings = _initialSpacings!;

    ElementPosition lowestElementPosition = const ElementPosition(
      step: Step.F,
      octave: 4,
    );

    double heightToStaffTop = offsetPerPosition;
    heightToStaffTop *= ElementPosition.staffTop.numeric;

    double paddingToTop = 0;

    // Padding to top currently calculates pretending that whole element is painted
    // above it's position. Elements like clef, sharps is drawn onto position but
    // some parts can be drawn below that position.
    for (var child in children) {
      double heightToChildTop = offsetPerPosition;
      heightToChildTop *= child.position.numeric;
      heightToChildTop += child.size.height;

      double heightOverStaff = heightToChildTop - heightToStaffTop;
      heightOverStaff += child.defaultBottomPosition;
      if (paddingToTop < heightOverStaff) {
        paddingToTop = heightOverStaff;
      }
      if (lowestElementPosition > child.position) {
        lowestElementPosition = child.position;
      }
    }
    double paddingToBottom = offsetPerPosition *
        [
          lowestElementPosition.distanceFromBottom,
          _minPositionPadding,
        ].max;

    double verticalPadding = [paddingToBottom, paddingToTop].max;
    verticalPadding += NotationLayoutProperties.staffLineStrokeWidth / 2;

    var finalChildren = <Widget>[];
    for (var (index, child) in children.indexed) {
      var fromBottom = -child.position.offset.dy + verticalPadding;
      fromBottom += child.defaultBottomPosition;
      finalChildren.add(
        Positioned(
          left: spacings[index],
          bottom: fromBottom,
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
          ...finalChildren,
        ],
      );
    });
  }
}

class StaffLines extends StatelessWidget {
  final bool startBarline;
  final bool endBarline;

  const StaffLines({
    super.key,
    this.startBarline = false,
    this.endBarline = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (startBarline)
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
        if (endBarline)
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

extension ElementPositionOffset on ElementPosition {
  Offset get offset {
    double offsetY;

    switch (step) {
      case Step.B:
        offsetY = 2;
      case Step.A:
        offsetY = 1;
      case Step.G:
        offsetY = 0;
      case Step.F:
        offsetY = -1;
      case Step.E:
        offsetY = -2;
      case Step.D:
        offsetY = -3;
      case Step.C:
        offsetY = -4;
    }
    return Offset(0, -(NotationLayoutProperties.staveSpace / 2) * offsetY) +
        Offset(0, (octave - 4) * -42);
  }
}
