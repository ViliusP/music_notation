import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:music_notation/src/models/data_types/step.dart';
import 'package:music_notation/src/models/elements/music_data/note/note_type.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/models/visual_note_element.dart';
import 'package:music_notation/src/notation_painter/music_grid.dart';
import 'package:music_notation/src/notation_painter/notation_layout_properties.dart';
import 'package:music_notation/src/notation_painter/painters/barline_painter.dart';
import 'package:music_notation/src/notation_painter/painters/measure_painter.dart';
import 'package:music_notation/src/notation_painter/painters/note_painter.dart';
import 'package:music_notation/src/notation_painter/painters/staff_lines_painter.dart';
import 'package:music_notation/src/notation_painter/painters/stem_painter.dart';
import 'package:music_notation/src/notation_painter/staff_painter_context.dart';

class Measure extends StatelessWidget {
  final MeasureSequence sequence;

  const Measure({
    super.key,
    required this.sequence,
  });

  @override
  Widget build(BuildContext context) {
    final context = StaffPainterContext();
    var notes = <Widget>[];

    const offsetPerPosition = NotationLayoutProperties.staveSpace / 2;

    var range = sequence.range;

    var defaultLowest = const ElementPosition(step: Step.F, octave: 4);
    var defaultHighest = const ElementPosition(step: Step.E, octave: 5);

    var maxPositionsBelow =
        defaultLowest.numericPosition - range.lowest.position.numericPosition;
    var maxPositionsAbove =
        range.highest.position.numericPosition - defaultHighest.numericPosition;

    print("below $maxPositionsBelow | above $maxPositionsAbove");

    double defaultOffset = offsetPerPosition *
        [maxPositionsBelow, maxPositionsAbove, 0].max.toDouble();
    context.moveX(20);
    for (var column in sequence) {
      VisualNoteElement? lowestNote;
      VisualNoteElement? highestNote;
      double? rightMargin;
      for (var element in column) {
        var musicElement = element;
        if (musicElement == null) continue;
        if (musicElement.defaultMargins != null) {
          context.moveX(musicElement.defaultMargins!.left);
          rightMargin = musicElement.defaultMargins!.right;
        }

        var offset = context.offset +
            musicElement.defaultOffset +
            musicElement.position.step
                .calculteOffset(musicElement.position.octave);

        // 'highestNote' is same as note before.
        // The stem is always placed between the two notes of an interval of a 2nd,
        // with the upper note always to the right, the lower note always to the left.
        if (highestNote != null && musicElement is VisualNoteElement) {
          var distance = (highestNote.position.numericPosition -
                  musicElement.position.numericPosition)
              .abs();
          // If neighboring interval of notes is second
          if (distance == 1) {
            offset += const Offset(14, 0);
          }
        }

        if (musicElement is VisualNoteElement) {
          notes.add(
            Positioned(
              bottom: defaultOffset - offset.dy,
              child: Padding(
                padding: EdgeInsets.only(
                  left: offset.dx,
                  // top: defaultOffset,
                ),
                child: Note(
                  note: musicElement,
                ),
              ),
            ),
          );
        }

        if (musicElement is VisualNoteElement) {
          lowestNote ??= musicElement;
          highestNote = musicElement;
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

      context.moveX(rightMargin ?? 48);
    }

    return Stack(
      fit: StackFit.loose,
      children: [
        CustomPaint(
          size: BarlinePainter.size,
          painter: BarlinePainter(),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: defaultOffset),
          child: CustomPaint(
            size: Size(
              context.offset.dx,
              NotationLayoutProperties.staveHeight,
            ),
            painter: StaffLinesPainter(),
          ),
        ),
        ...notes,
      ],
    );
  }
}

class Note extends StatelessWidget {
  final VisualNoteElement note;

  const Note({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      // mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Notehead(
          type: note.type,
          stemmed: note.stemmed,
        ),
        if (note.stemmed)
          Padding(
            padding: const EdgeInsets.only(
              bottom: NotationLayoutProperties.noteHeadHeight / 2,
            ),
            child: Stem(
              type: note.type,
            ),
          )
      ],
    );
  }
}

class Notehead extends StatelessWidget {
  final NoteTypeValue type;

  /// If note are stemmed, notehead's width will be reduces for aesthetics.
  final bool stemmed;

  const Notehead({super.key, required this.type, required this.stemmed});

  @override
  Widget build(BuildContext context) {
    double notesWidth = type.noteheadWidth;

    if (stemmed) {
      notesWidth -= NotationLayoutProperties.stemStrokeWidth;
    }

    Size size = Size(
      notesWidth,
      NotationLayoutProperties.noteHeadHeight,
    );

    return CustomPaint(
      size: size,
      painter: NotePainter(type.smuflSymbol),
    );
  }
}

class Stem extends StatelessWidget {
  final NoteTypeValue type;
  final double heigth;

  const Stem({
    super.key,
    required this.type,
    this.heigth = NotationLayoutProperties.standardStemHeight,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(StemPainter.strokeWidth + type.flagWidth, heigth),
      painter: StemPainter(
        flagSmufl: type.upwardFlag,
      ),
    );
  }
}
