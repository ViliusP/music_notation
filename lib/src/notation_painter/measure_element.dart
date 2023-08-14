import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:music_notation/src/models/data_types/step.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/models/elements/score/part.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/music_grid.dart';
import 'package:music_notation/src/notation_painter/notation_layout_properties.dart';
import 'package:music_notation/src/notation_painter/note_element.dart';
import 'package:music_notation/src/notation_painter/painters/barline_painter.dart';
import 'package:music_notation/src/notation_painter/painters/staff_lines_painter.dart';
import 'package:music_notation/src/notation_painter/staff_painter_context.dart';

class MeasureElement extends StatelessWidget {
  static const double _minPositionPadding = 4;

  final Measure measure;
  final MeasureSequence sequence;
  final int? staff;
  double? get _cachedMinWidth => _initialSpacings?.last;

  final List<double>? _initialSpacings;

  MeasureElement({
    super.key,
    required this.measure,
    this.staff,
  })  : _initialSpacings = null,
        sequence = MeasureSequence.fromMeasure(measure: measure, staff: staff);

  MeasureElement._withCache({
    super.key,
    required this.measure,
    required List<double> initialSpacings,
    this.staff,
  })  : _initialSpacings = initialSpacings,
        sequence = MeasureSequence.fromMeasure(measure: measure, staff: staff);

  factory MeasureElement.withCaching({
    Key? key,
    required Measure measure,
    int? staff,
  }) {
    return MeasureElement._withCache(
      key: key,
      measure: measure,
      staff: staff,
      initialSpacings: _calculateInitialSpacings(
        MeasureSequence.fromMeasure(measure: measure, staff: staff),
      ),
    );
  }

  static List<double> _calculateInitialSpacings(MeasureSequence sequence) {
    final context = StaffPainterContext();
    List<double> spacings = [];
    context.moveX(20);
    for (var column in sequence) {
      double? rightMargin;
      for (var element in column) {
        var musicElement = element;
        if (musicElement == null) continue;
        if (musicElement.defaultMargins != null) {
          context.moveX(musicElement.defaultMargins!.left);
          rightMargin = musicElement.defaultMargins!.right;
        }
      }
      spacings.add(context.offset.dx);
      context.moveX(rightMargin ?? 48);
    }
    spacings.add(context.offset.dx);

    return spacings;
  }

  @override
  Widget build(BuildContext context) {
    var notes = <Widget>[];

    const offsetPerPosition = NotationLayoutProperties.staveSpace / 2;

    var range = sequence.range;

    var defaultLowest = const ElementPosition(step: Step.F, octave: 4);
    var defaultHighest = const ElementPosition(step: Step.E, octave: 5);

    var maxPositionsBelow =
        defaultLowest.numericPosition - range.lowest.position.numericPosition;
    var maxPositionsAbove =
        range.highest.position.numericPosition - defaultHighest.numericPosition;

    double defaultOffset = offsetPerPosition *
        [maxPositionsBelow, maxPositionsAbove, _minPositionPadding].max;

    List<double> spacings =
        _initialSpacings ?? _calculateInitialSpacings(sequence);
    int i = 0;
    for (var column in sequence) {
      NoteElement? lowestNote;
      NoteElement? highestNote;
      for (var element in column) {
        var musicElement = element;
        if (musicElement == null) continue;

        if (musicElement.equivalent is Note) {
          NoteElement noteElement = NoteElement(note: musicElement.equivalent);
          var offset = Offset(spacings[i], 0) +
              musicElement.defaultOffset +
              (noteElement.position?.step ?? Step.C)
                  .calculteOffset(noteElement.position?.octave ?? 5);
          // 'highestNote' is same as note before.
          // The stem is always placed between the two notes of an interval of a 2nd,
          // with the upper note always to the right, the lower note always to the left.
          if (highestNote != null && highestNote.position != null) {
            var distance = (highestNote.position!.numericPosition -
                    musicElement.position.numericPosition)
                .abs();
            // If neighboring interval of notes is second
            if (distance == 1) {
              offset += const Offset(14, 0);
            }
          }

          notes.add(
            Positioned(
              bottom: defaultOffset - offset.dy,
              child: Padding(
                padding: EdgeInsets.only(
                  left: offset.dx,
                ),
                child: noteElement,
              ),
            ),
          );

          lowestNote ??= noteElement;
          highestNote = noteElement;
          continue;
        }
      }
      if (lowestNote != null) {
        // _paintLedgerLines(
        //   count: lowestNote.ledgerLines,
        //   noteheadWidth: lowestNote.noteheadWidth,
        //   canvas: canvas,
        //   size: size,
        //   context: context,
        // );
      }
      // _drawStemForColumn(
      //   lowestNote,
      //   highestNote,
      //   canvas: canvas,
      //   size: size,
      //   context: context,
      // );
      i++;
    }

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
          ...notes,
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
