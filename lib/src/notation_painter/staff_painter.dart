import 'package:flutter/rendering.dart';

import 'package:music_notation/src/models/data_types/step.dart';

import 'package:music_notation/src/models/elements/music_data/note/stem.dart';
import 'package:music_notation/src/models/elements/score/score.dart';
import 'package:music_notation/src/notation_painter/models/visual_note_element.dart';
import 'package:music_notation/src/notation_painter/music_grid.dart';
import 'package:music_notation/src/notation_painter/staff_painter_context.dart';

class PainterSettings {
  bool debugFrame = false;

  static final PainterSettings _instance = PainterSettings._();

  factory PainterSettings() {
    return _instance;
  }

  PainterSettings._();
}

class StaffPainter extends CustomPainter {
  final ScorePartwise score;
  final NotationGrid notationGrid;
  late StaffPainterContext context;

  /// Settings
  static const double staffHeight = 48;
  static const lineSpacing = staffHeight / 4;
  static const int _staffLines = 5;
  static const double staffLineStrokeWidth = 2;
  static const double ledgerLineWidth = 26;
  static const double _noteStemHeight = 42;
  static const double _stemStrokeWidth = 1.5;

  StaffPainter({
    required this.score,
    required this.notationGrid,
  });

  final Paint _axisPaint = Paint()
    ..color = const Color(0xFFFF5252)
    ..strokeWidth = 1.0;

  @override
  void paint(Canvas canvas, Size size) {
    context = StaffPainterContext(
      canvas: canvas,
      size: size,
    );
    var grid = notationGrid;
    // Iterating throug part/row.
    for (var i = 0; i < grid.data.rowCount; i++) {
      _paintBarline(canvas, context);

      // Iterating throug measures/part.
      for (var j = 0; j < grid.data.columnCount; j++) {
        var measureGrid = grid.data.getValue(i, j);
        _paintMeasure(grid: measureGrid);
        if (j != grid.data.columnCount - 1) _paintBarline(canvas, context);
      }
      _paintStaffLines(canvas, context);

      _paintBarline(canvas, context);

      context.resetX();
      context.moveY(120);
    }

    PainterSettings().debugFrame ? paintCoordinates(canvas, size) : () {};
  }

  void _paintMeasure({required MeasureGrid grid}) {
    for (var j = 0; j < grid.elementCount; j++) {
      VisualNoteElement? lowestNote;
      VisualNoteElement? highestNote;
      double? rightMargin;
      for (var i = -grid.distance; i < grid.distance; i++) {
        var musicElement = grid.getValue(i, j);
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
          if (distance == 1) {
            offset += const Offset(14, 0);
          }
        }

        drawSmuflSymbol(
          context.canvas,
          offset,
          musicElement.symbol,
        );
        if (musicElement is VisualNoteElement) {
          lowestNote ??= musicElement;
          highestNote = musicElement;
        }
      }
      if (lowestNote != null) {
        _paintLedgerLines(
          count: lowestNote.ledgerLines,
        );
      }
      _drawStemForColumn(lowestNote, highestNote);

      context.moveX(rightMargin ?? 48);
    }
  }

  /// Notes below line 3 have up stems on the right side of the notehead.

  /// Notes on or above line 3 have down stems on the left side of the notehead.
  ///
  /// The stem is awalys placed between the two notes of an interval of a 2nd,
  /// with the upper note always to the right, the lower note always to the left.
  ///
  /// When two notes share a stem:
  /// - If the interval above the middle line is greater, the stem goes down;
  /// - If the interval below the middle line is geater, the stem goes up;
  /// - If the intervals above and below the middle ine are equidistant, the stem
  /// goes down;
  ///
  /// When more than two notes share a stem, the direction is determined by the
  /// highest and the lowest notes:
  /// - If the interval from the highest note to the middle line is greater,
  /// the stem goes down;
  /// - If the interval from the lowest note to the middle line is greater, the
  /// stem goes up;
  /// - If equidistant the stem goes down.
  ///
  /// TODO: need to take account of different voices on the same staff:
  /// If you are writing two vocies on the same staff, the stems for the upper
  /// voice will go up, and the stems for the lower voice will go down.
  void _drawStemForColumn(
    VisualNoteElement? lowestNote,
    VisualNoteElement? highestNote,
  ) {
    // If only one note exists in column.
    if (lowestNote != null && lowestNote == highestNote && lowestNote.stemmed) {
      var offset = context.offset +
          lowestNote.defaultOffset +
          lowestNote.position.step.calculteOffset(lowestNote.position.octave);

      final StemValue stemDirection =
          lowestNote.distanceFromMiddle < 0 ? StemValue.up : StemValue.down;

      String? flagSymbol = stemDirection == StemValue.up
          ? lowestNote.flagUpSymbol
          : lowestNote.flagDownSymbol;

      _drawStem(
        noteOffset: offset,
        flagSymbol: flagSymbol,
        direction: stemDirection,
      );
    }
    if (lowestNote != null &&
        highestNote != null &&
        lowestNote != highestNote) {
      StemValue stemDirection = StemValue.down;
      if (lowestNote.distanceFromMiddle.abs() >
          highestNote.distanceFromMiddle.abs()) {
        stemDirection = StemValue.up;
      }

      var lowestNoteOffsetY = context.offset +
          lowestNote.defaultOffset +
          lowestNote.position.step.calculteOffset(lowestNote.position.octave);

      var highestNoteOffsetY = context.offset +
          highestNote.defaultOffset +
          highestNote.position.step.calculteOffset(highestNote.position.octave);

      Offset notesOffset = lowestNoteOffsetY;
      if (lowestNote.distanceFromMiddle.abs() <
          highestNote.distanceFromMiddle.abs()) {
        notesOffset = highestNoteOffsetY;
      }

      String? flagSymbol = stemDirection == StemValue.up
          ? lowestNote.flagUpSymbol
          : lowestNote.flagDownSymbol;

      _drawStem(
        noteOffset: notesOffset,
        flagSymbol: flagSymbol,
        direction: stemDirection,
        stemHeight:
            _noteStemHeight + lowestNoteOffsetY.dy - highestNoteOffsetY.dy,
      );
    }
  }

  void _drawStem({
    required Offset noteOffset,
    String? flagSymbol,
    required StemValue direction,
    double stemHeight = _noteStemHeight,
  }) {
    // Stem offset note's offset. DX offset 15 values are chosen manually.
    Offset stemOffset = noteOffset + const Offset(15, _noteStemHeight);
    if (direction == StemValue.down) {
      stemOffset = noteOffset + const Offset(1, _noteStemHeight);
    }

    int stemHeightMultiplier = direction == StemValue.down ? 1 : -1;

    context.canvas.drawLine(
      stemOffset,
      stemOffset + Offset(0, stemHeightMultiplier * stemHeight),
      Paint()
        ..color = const Color.fromRGBO(0, 0, 0, 1.0)
        ..strokeWidth = _stemStrokeWidth,
    );
    if (flagSymbol != null) {
      var stemFlagOffset = direction == StemValue.down
          ? noteOffset - Offset(0, -stemHeight)
          : noteOffset + Offset(15, -stemHeight);

      drawSmuflSymbol(context.canvas, stemFlagOffset, flagSymbol);
    }
  }

  void _paintLedgerLines({
    required int count,
  }) {
    if (count == 0) {
      return;
    }

    int multiplier = count.isNegative ? 1 : -1;

    double startingY = count.isNegative ? 48 : 0;

    var positionY = (startingY + lineSpacing) * multiplier;
    for (var i = 0; i < count.abs(); i++) {
      context.canvas.drawLine(
        context.offset + Offset(multiplier * -5, positionY),
        context.offset + Offset(multiplier * 20, positionY),
        Paint()
          ..color = const Color.fromRGBO(0, 0, 0, 1.0)
          ..strokeWidth = staffLineStrokeWidth,
      );

      positionY += multiplier * lineSpacing;
    }
  }

  void _paintBarline(Canvas canvas, StaffPainterContext context) {
    Paint linePainter = Paint()
      ..color = const Color.fromRGBO(0, 0, 0, 1.0)
      ..strokeWidth = 1.5;

    canvas.drawLine(
      context.offset,
      context.offset + const Offset(0, staffHeight),
      linePainter,
    );

    context.moveX(12);
  }

  void _paintStaffLines(Canvas canvas, StaffPainterContext context) {
    var lineY = 0.0;
    for (var i = 0; i < _staffLines; i++) {
      canvas.drawLine(
        Offset(0, lineY + context.offset.dy),
        // probably need to fix.
        Offset(context.offset.dx, lineY + context.offset.dy),
        Paint()
          ..color = const Color.fromRGBO(0, 0, 0, 1.0)
          ..strokeWidth = staffLineStrokeWidth,
      );
      lineY += lineSpacing;
    }
  }

  void paintCoordinates(Canvas canvas, Size size) {
    canvas.drawLine(
      Offset(0, size.height - 10),
      Offset(size.width, size.height - 10),
      _axisPaint,
    );
    for (double i = 0; i < size.width; i += 12) {
      canvas.drawLine(
        Offset(i, size.height - 12),
        Offset(i, size.height - 24),
        _axisPaint,
      );
    }

    for (double i = 0; i < size.height; i += 12) {
      canvas.drawLine(
        Offset(12, i),
        Offset(24, i),
        _axisPaint,
      );
    }

    // Draw y-axis
    canvas.drawLine(
      const Offset(10, 0),
      Offset(10, size.height),
      _axisPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

void drawSmuflSymbol(
  Canvas canvas,
  Offset offset,
  String symbol, [
  double fontSize = 48,
]) {
  final textStyle = TextStyle(
    fontFamily: 'Sebastian',
    fontSize: fontSize,
    color: const Color.fromRGBO(0, 0, 0, 1.0),
  );
  final textPainter = TextPainter(
    text: TextSpan(text: symbol, style: textStyle),
    textDirection: TextDirection.ltr,
  );
  textPainter.layout();

  if (PainterSettings().debugFrame) {
    final borderRect = Rect.fromLTWH(
      offset.dx,
      offset.dy,
      textPainter.width + 8.0,
      textPainter.height + 8.0,
    );
    final borderPaint = Paint()
      ..color = const Color.fromRGBO(0, 0, 0, 1.0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawRect(borderRect, borderPaint);
  }
  textPainter.paint(
    canvas,
    Offset(offset.dx, offset.dy),
  );
}

extension SymbolPosition on Step {
  /// Calculates offset needed to draw on staff.
  Offset calculteOffset(int octave) {
    double offsetY;

    switch (this) {
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
    return Offset(0, (StaffPainter.lineSpacing / 2) * -offsetY) +
        Offset(0, (octave - 4) * -42);
  }
}

enum LedgerPlacement {
  above,
  below;
}
