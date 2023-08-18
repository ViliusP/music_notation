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
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/models/elements/score/part.dart';
import 'package:music_notation/src/notation_painter/attributes_elements.dart';
import 'package:music_notation/src/notation_painter/key_element.dart';
import 'package:music_notation/src/notation_painter/measure_element.dart';
import 'package:music_notation/src/notation_painter/models/notation_context.dart';
import 'package:music_notation/src/notation_painter/notation_layout_properties.dart';
import 'package:music_notation/src/notation_painter/note_element.dart';
import 'package:music_notation/src/notation_painter/painters/barline_painter.dart';
import 'package:music_notation/src/notation_painter/painters/staff_lines_painter.dart';
import 'package:music_notation/src/notation_painter/time_beat_element.dart';

typedef _MeasureElementBuilder = Widget Function(
  BuildContext context,
  double initialBottom,
  double leftOffset,
);

class MeasureLayout extends StatelessWidget {
  static const double _minPositionPadding = 4;

  final Measure measure;
  // ignore: unused_field
  final NotationContext _contextBefore;
  final NotationContext contextAfter;

  final int? staff;
  double? get _cachedMinWidth => _initialSpacings?.last;

  final List<double>? _initialSpacings;

  final List<_MeasureElementBuilder>? _precomputedChildren;

  // const MeasureLayout({
  //   super.key,
  //   required this.measure,
  //   this.staff,
  //   required NotationContext? notationContext,
  // })  : _initialSpacings = null,
  //       _precomputedChildren = null,
  //       _notationContext = notationContext;

  const MeasureLayout._({
    super.key,
    required this.measure,
    required List<double> initialSpacings,
    required final List<_MeasureElementBuilder> precomputedBuilders,
    this.staff,
    required NotationContext contextBefore,
    required this.contextAfter,
  })  : _initialSpacings = initialSpacings,
        _precomputedChildren = precomputedBuilders,
        _contextBefore = contextBefore;

  factory MeasureLayout.fromMeasureData({
    Key? key,
    required Measure measure,
    int? staff,
    required NotationContext notationContext,
  }) {
    var precomputes = _computeBuilders(
      notationContext,
      measure,
      staff,
    );

    return MeasureLayout._(
      key: key,
      measure: measure,
      staff: staff,
      initialSpacings: precomputes.spacings,
      precomputedBuilders: precomputes.builders,
      contextBefore: notationContext,
      contextAfter: precomputes.contextAfter,
    );
  }

  /// Returns initial list of spacings that do not consider measure stretching and compression [measure].
  static ({
    NotationContext contextAfter,
    List<double> spacings,
    List<_MeasureElementBuilder> builders,
  }) _computeBuilders(
    NotationContext contextBefore,
    Measure measure,
    int? staff,
  ) {
    NotationContext contextAfter = contextBefore.copyWith();

    const horizontalPadding = 8.0;

    double leftOffset = horizontalPadding;

    // Will be change in future.
    const spacingBetweenElements = 8;

    final List<double> spacings = [];

    final builders = <_MeasureElementBuilder>[];

    for (var element in measure.data) {
      switch (element) {
        case Note _:
          if (staff == element.staff || staff == null) {
            if (contextAfter.divisions == null) {
              throw ArgumentError(
                "Context or measure must have divisions in attributes element",
              );
            }

            var noteElement = NoteElement(
              note: element,
              divisions: contextAfter.divisions!,
            );

            builders.add(
              (context, leftOffset, initialBottom) => MeasureElement(
                clef: contextAfter.clef,
                position: noteElement.position,
                bottom: initialBottom,
                left: leftOffset,
                child: noteElement,
              ),
            );

            spacings.add(leftOffset);
            if (element.chord == null) {
              // TOOD: change to noteElement.size.width
              leftOffset += spacingBetweenElements + 16;
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
            var clefElement = ClefElement(clef: clef);

            builders.add(
              (context, leftOffset, initialBottom) => MeasureElement(
                position: clefElement.position,
                left: leftOffset,
                bottom: initialBottom + clefElement.measureOffset.dy,
                child: clefElement,
              ),
            );
            spacings.add(leftOffset);
            leftOffset += spacingBetweenElements + clefElement.size.width;
          }
          // -----------------------------
          // Time
          // -----------------------------

          for (var times in element.times) {
            switch (times) {
              case TimeBeat _:
                var timeBeatWidget = TimeBeatElement(timeBeat: times);

                builders.add(
                  (context, leftOffset, initialBottom) => MeasureElement(
                    position: timeBeatWidget.position,
                    // influencedByClef: false,
                    left: leftOffset,
                    bottom: initialBottom - 16,
                    child: timeBeatWidget,
                  ),
                );

                spacings.add(leftOffset);
                // TOOD: change to timeBeatWidget.size.width
                leftOffset += spacingBetweenElements + 20;
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
          var keySignature = KeySignature.fromKeyData(keyData: musicKey);
          if (keySignature.firstPosition != null) {
            builders.add(
              (context, leftOffset, initialBottom) => MeasureElement(
                position: keySignature.firstPosition!,
                clef: contextAfter.clef,
                left: leftOffset,
                bottom: initialBottom - 16,
                child: keySignature,
              ),
            );
            spacings.add(leftOffset);
            leftOffset += spacingBetweenElements + keySignature.size.width;
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
    }
    // TODO: change to something smarter, it must be constant or it has to be
    // dependent on width of measure.
    // Adding padding to measure's end.
    spacings.add(leftOffset + horizontalPadding);
    return (
      contextAfter: contextAfter,
      spacings: spacings,
      builders: builders,
    );
  }

  @override
  Widget build(BuildContext context) {
    // var notes = <Widget>[];

    const offsetPerPosition = NotationLayoutProperties.staveSpace / 2;

    // var range = sequence.range;

    // var defaultLowest = const ElementPosition(step: Step.F, octave: 4);
    // var defaultHighest = const ElementPosition(step: Step.E, octave: 5);

    // var maxPositionsBelow =
    //     defaultLowest.numericPosition - range.lowest.position.numericPosition;
    // var maxPositionsAbove =
    //     range.highest.position.numericPosition - defaultHighest.numericPosition;
    var maxPositionsBelow = 5;
    var maxPositionsAbove = 4;
    double defaultOffset = offsetPerPosition *
        [maxPositionsBelow, maxPositionsAbove, _minPositionPadding].max;

    List<double> spacings = _initialSpacings!;
    var builders = _precomputedChildren!;

    List<Widget> children = [];
    for (var (index, builder) in builders.indexed) {
      children.add(
        builder(context, spacings[index], defaultOffset),
      );
    }

    // int i = 0;
    // for (var column in sequence) {
    //   NoteElement? lowestNote;
    //   NoteElement? highestNote;
    //   for (var element in column) {
    //     var musicElement = element;
    //     if (musicElement == null) continue;

    //     if (musicElement.equivalent is Note) {
    //       NoteElement noteElement = NoteElement(note: musicElement.equivalent);
    //       var offset = Offset(spacings[i], 0) +
    //           musicElement.defaultOffset +
    //           (noteElement.position?.step ?? Step.C)
    //               .calculteOffset(noteElement.position?.octave ?? 5);
    //       // 'highestNote' is same as note before.
    //       // The stem is always placed between the two notes of an interval of a 2nd,
    //       // with the upper note always to the right, the lower note always to the left.
    //       if (highestNote != null && highestNote.position != null) {
    //         var distance = (highestNote.position!.numericPosition -
    //                 musicElement.position.numericPosition)
    //             .abs();
    //         // If neighboring interval of notes is second
    //         if (distance == 1) {
    //           offset += const Offset(14, 0);
    //         }
    //       }

    //       notes.add(
    //         Positioned(
    //           bottom: defaultOffset - offset.dy,
    //           child: Padding(
    //             padding: EdgeInsets.only(
    //               left: offset.dx,
    //             ),
    //             child: noteElement,
    //           ),
    //         ),
    //       );

    //       lowestNote ??= noteElement;
    //       highestNote = noteElement;
    //       continue;
    //     }
    //   }
    //   if (lowestNote != null) {
    //     // _paintLedgerLines(
    //     //   count: lowestNote.ledgerLines,
    //     //   noteheadWidth: lowestNote.noteheadWidth,
    //     //   canvas: canvas,
    //     //   size: size,
    //     //   context: context,
    //     // );
    //   }
    //   // _drawStemForColumn(
    //   //   lowestNote,
    //   //   highestNote,
    //   //   canvas: canvas,
    //   //   size: size,
    //   //   context: context,
    //   // );
    //   i++;
    // }

    double width = _cachedMinWidth ?? spacings.last;

    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        fit: StackFit.loose,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: defaultOffset),
            child: SizedBox.fromSize(
              size: Size(
                constraints.maxWidth.isFinite ? constraints.maxWidth : width,
                NotationLayoutProperties.staveHeight,
              ),
              child: const StaffLines(),
            ),
          ),
          ...children,
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
