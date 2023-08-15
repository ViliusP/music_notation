import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

import 'package:music_notation/src/models/elements/music_data/attributes/attributes.dart';
import 'package:music_notation/src/models/elements/music_data/backup.dart';
import 'package:music_notation/src/models/elements/music_data/direction/direction.dart';
import 'package:music_notation/src/models/elements/music_data/forward.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/models/elements/score/part.dart';
import 'package:music_notation/src/notation_painter/attributes_elements.dart';
import 'package:music_notation/src/notation_painter/measure_element.dart';
import 'package:music_notation/src/notation_painter/notation_layout_properties.dart';
import 'package:music_notation/src/notation_painter/note_element.dart';
import 'package:music_notation/src/notation_painter/painters/barline_painter.dart';
import 'package:music_notation/src/notation_painter/painters/staff_lines_painter.dart';

typedef _MeasureElementBuilder = Widget Function(
  BuildContext context,
  double initialBottom,
  double leftOffset,
);

class MeasureLayout extends StatelessWidget {
  static const double _minPositionPadding = 4;

  final Measure measure;

  final int? staff;
  double? get _cachedMinWidth => _initialSpacings?.last;

  final List<double>? _initialSpacings;

  final List<_MeasureElementBuilder>? _precomputedChildren;

  const MeasureLayout({
    super.key,
    required this.measure,
    this.staff,
  })  : _initialSpacings = null,
        _precomputedChildren = null;

  const MeasureLayout._withCache({
    super.key,
    required this.measure,
    required List<double> initialSpacings,
    required final List<_MeasureElementBuilder> precomputedBuilders,
    this.staff,
  })  : _initialSpacings = initialSpacings,
        _precomputedChildren = precomputedBuilders;

  factory MeasureLayout.withCaching({
    Key? key,
    required Measure measure,
    int? staff,
  }) {
    var precomputes = _precomputeChildrenBuilders(measure, staff);

    return MeasureLayout._withCache(
      key: key,
      measure: measure,
      staff: staff,
      initialSpacings: precomputes.spacings,
      precomputedBuilders: precomputes.builders,
    );
  }

  /// Returns initial list of spacings that do not consider measure stretching and compression [measure].
  static ({
    List<double> spacings,
    List<_MeasureElementBuilder> builders,
  }) _precomputeChildrenBuilders(
    Measure measure,
    int? staff,
  ) {
    double spacing = 0;

    final List<double> spacings = [];

    final builders = <_MeasureElementBuilder>[];

    for (var element in measure.data) {
      switch (element) {
        case Note _:
          if (staff == element.staff || staff == null) {
            var noteElement = NoteElement(
              note: element,
            );
            if (element.chord == null) {
              spacing += 40;
            }

            builders.add(
              (context, leftOffset, initialBottom) => MeasureElement(
                position: noteElement.position,
                bottom: initialBottom,
                left: leftOffset,
                child: noteElement,
              ),
            );
          }
          break;

        case Backup _:
          break;
        case Forward _:
          break;
        case Direction _:
          break;
        case Attributes _:
          if (element.clefs.isNotEmpty) {
            if (element.clefs.length > 1 && staff == null) {
              throw UnimplementedError(
                "Multiple clef signs is not implemented in renderer yet",
              );
            }
            spacing += 30;

            var clefElement = ClefElement(
                clef: element.clefs.firstWhere(
              (element) => staff != null ? element.number == staff : true,
            ));

            builders.add(
              (context, leftOffset, initialBottom) => MeasureElement(
                position: clefElement.position,
                left: leftOffset,
                bottom: initialBottom,
                child: clefElement,
              ),
            );
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
      spacings.add(spacing);
    }
    spacings.add(spacings.last + 100);
    return (spacings: spacings, builders: builders);
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

    List<double> spacings = _initialSpacings ?? [];
    var builders = _precomputedChildren ?? [];
    if (_initialSpacings == null && _precomputedChildren == null) {
      var childrenData = _precomputeChildrenBuilders(measure, staff);
      spacings = childrenData.spacings;
      builders = childrenData.builders;
    }

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
          // Stack(
          //   children: children,
          // ),
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
