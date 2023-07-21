import 'package:flutter/rendering.dart';

import 'package:music_notation/src/models/data_types/step.dart';

import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/models/elements/score/score.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
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
  static const double _staffLineStrokeWidth = 1;
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
      for (var i = -grid.distance; i < grid.distance; i++) {
        var musicElement = grid.getValue(i, j);
        if (musicElement == null) continue;
        double offsetY = _calculateElementOffsetY(
          musicElement.position.step,
          musicElement.position.octave,
          musicElement.defaultOffset.dy,
        );

        var offset = context.offset + Offset(0, offsetY);

        drawSmuflSymbol(
          context.canvas,
          offset,
          musicElement.symbol,
        );

        if (musicElement is VisualNoteElement &&
            musicElement.stemDirection != StemDirection.none) {
          String? flagSymbol = musicElement.stemDirection == StemDirection.up
              ? musicElement.flagUpSymbol
              : musicElement.flagDownSymbol;

          _drawStem(
            noteOffset: offset,
            flagSymbol: flagSymbol,
            direction: musicElement.stemDirection,
          );
        }
      }
      context.moveX(40);
    }
  }

  void _drawStem({
    required Offset noteOffset,
    String? flagSymbol,
    required StemDirection direction,
  }) {
    // Stem offset note's offset.
    Offset stemOffset = noteOffset + const Offset(15, 40);
    if (direction == StemDirection.down) {
      stemOffset = noteOffset + const Offset(1, 40);
    }

    int stemHeightMultiplier = direction == StemDirection.down ? 1 : -1;

    context.canvas.drawLine(
      stemOffset,
      stemOffset + Offset(0, stemHeightMultiplier * _noteStemHeight),
      Paint()
        ..color = const Color.fromRGBO(0, 0, 0, 1.0)
        ..strokeWidth = _stemStrokeWidth,
    );
    if (flagSymbol != null) {
      var stemFlagOffset = direction == StemDirection.down
          ? stemOffset
          : noteOffset + const Offset(15, -_noteStemHeight);

      drawSmuflSymbol(context.canvas, stemFlagOffset, flagSymbol);
    }
  }

  // void _drawNotes({
  //   required StaffPainterContext context,
  //   required Note note,
  // }) {
  //   switch (note) {
  //     case RegularNote _:
  //       if (note.type != null) {
  //         if (note.chord != null) {
  //           context.moveX(-40);
  //         }

  //         double offsetY = _calculateElementOffsetY(
  //           note.form.step!,
  //           note.form.octave!,
  //         );
  //         // double offsetX = _calculateNote
  //         drawSmuflSymbol(
  //           context.canvas,
  //           context.offset + Offset(0, offsetY),
  //           NoteHeadSmufl.getSmuflSymbol(note.type!.value),
  //         );
  //         var additionalLines = ledgerLines(note.form);
  //         if (additionalLines != null) {
  //           _paintLedgerLines(
  //             canvas: context.canvas,
  //             count: additionalLines.count,
  //             placement: additionalLines.placement,
  //             positionX: context.offset.dx,
  //           );
  //         }
  //         context.moveX(40);
  //       }
  //       break;
  //     default:
  //       break;
  //   }
  // }

  void _paintLedgerLines({
    required Canvas canvas,
    required int count,
    required LedgerPlacement placement,
    required double positionX,
  }) {
    int multiplier = placement == LedgerPlacement.below ? 1 : -1;

    double startingY = placement == LedgerPlacement.below ? 48 : 0;

    var positionY = (startingY + lineSpacing) * multiplier;
    for (var i = 0; i < count; i++) {
      double center = 7.5 + positionX;
      double x1 = center - (ledgerLineWidth / 2);
      double x2 = center + (ledgerLineWidth / 2);

      canvas.drawLine(
        Offset(x1, positionY),
        Offset(x2, positionY),
        Paint()
          ..color = const Color.fromRGBO(0, 0, 0, 1.0)
          ..strokeWidth = _staffLineStrokeWidth * 1,
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

  ({int count, LedgerPlacement placement})? ledgerLines(NoteForm form) {
    // TODO fix nullable

    int position =
        ElementPosition(step: form.step ?? Step.G, octave: form.octave ?? 4)
            .numericPosition;
    // 29 - D in 4 octave.
    // 39 - G in 5 octave.
    if (position < 29) {
      int distance = 29 - position;

      return (count: (distance / 2).ceil(), placement: LedgerPlacement.below);
    }

    if (position > 39) {
      int distance = position - 39;

      return (count: (distance / 2).ceil(), placement: LedgerPlacement.above);
    }

    return null;
  }

  double _calculateElementOffsetY(
    Step step,
    int octave, [
    double startingY = 0,
  ]) {
    const distancePerOctace = 41;
    const startingOctave = 4; // Because starting note is G4.

    return step.calculateY(startingY) -
        ((octave - startingOctave) * distancePerOctace);
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
          ..strokeWidth = _staffLineStrokeWidth,
      );
      lineY = (i + 1) * (lineSpacing);
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
  /// Calculates something 🙂.
  double calculateY(double startingY) {
    // Need to fix "starting * n", because when it is startingY=0, it returns useless number.
    switch (this) {
      case Step.B:
        return (startingY * 2.75) - 3;
      case Step.A:
        return (startingY * 2) - 1;
      case Step.G:
        return (startingY * 1);
      case Step.F:
        return (startingY * 0) + 1;
      case Step.E:
        return (startingY * -1.75) - 3;
      case Step.D:
        return (startingY * -2.75) - 2;
      case Step.C:
        return (startingY * -3.75) - 1;
    }
  }
}

enum LedgerPlacement {
  above,
  below;
}
