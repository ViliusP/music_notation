import 'package:flutter/rendering.dart';

import 'package:music_notation/src/models/data_types/step.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/attributes.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/key.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/time.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/models/elements/music_data/note/note_type.dart';
import 'package:music_notation/src/models/elements/score/score.dart';

class StaffPainter extends CustomPainter {
  final ScorePartwise score;

  /// Settings
  static const double staffHeight = 48;
  static const lineSpacing = staffHeight / 4;
  static const int _staffLines = 5;
  static const double _staffLineStrokeWidth = 1;
  static const bool debugFrame = false;
  static const double ledgerLineWidth = 30;

  StaffPainter({
    required this.score,
  });

  final Paint _axisPaint = Paint()
    ..color = const Color(0xFFFF5252)
    ..strokeWidth = 1.0;

  static const List<String> clefSymbols = [
    '\uE050', // Treble Clef -5 y offset
    '\uE062', // Bass Clef
    '\uE05C', // Tenor Clef
    '\uE058', // Alto Clef
    '\uE063', // Percussion Clef
    '\uE057', // Soprano Clef
    '\uE059', // Mezzo-soprano Clef
    '\uE05E', // Baritone Clef
    '\uE055', // French Violin Clef
    '\uE061', // Tab Clef
    '\uE05F', // Neutral Clef
    '\uE1D6',
    '\uE1DC',
  ];

  @override
  void paint(Canvas canvas, Size size) {
    StaffPainterContext context = StaffPainterContext(
      canvas: canvas,
      size: size,
    );

    for (var part in score.parts) {
      for (var measure in part.measures) {
        for (var musicElement in measure.data) {
          switch (musicElement) {
            case Note _:
              _drawNotes(context: context, note: musicElement);
              break;
            case Attributes _:
              _drawAttributes(context: context, attributes: musicElement);
              break;
            default:
              break;
          }
        }
      }
    }

    _paintStaffLines(canvas, context);
    _paintEndingBarline(canvas, context);

    debugFrame ? paintCoordinates(canvas, size) : () {};
  }

  void _drawNotes({
    required StaffPainterContext context,
    required Note note,
  }) {
    switch (note) {
      case RegularNote _:
        if (note.type != null) {
          double offsetY = _calculateNoteOffsetY(note.form);
          drawSmuflSymbol(
            context.canvas,
            Offset(context.x, offsetY),
            NoteHeadSmufl.getSmuflSymbol(note.type!.value),
          );
          var additionalLines = ledgerLines(note.form);
          if (additionalLines != null) {
            _paintLedgerLines(
              canvas: context.canvas,
              count: additionalLines.count,
              placement: additionalLines.placement,
              positionX: context.x,
            );
          }
          context.x += 40;
        }
        break;
      default:
        break;
    }
  }

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
      double center = 10.5 + positionX;
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

  void _paintEndingBarline(Canvas canvas, StaffPainterContext context) {
    Paint linePainter = Paint()
      ..color = const Color.fromRGBO(0, 0, 0, 1.0)
      ..strokeWidth = 1.5;

    canvas.drawLine(
      Offset(context.x, 0),
      Offset(context.x, staffHeight),
      linePainter,
    );
  }

  ({int count, LedgerPlacement placement})? ledgerLines(NoteForm form) {
    // TODO fix nullable

    int position = (form.step ?? Step.G).position(form.octave ?? 4);
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

  double _calculateNoteOffsetY(NoteForm form) {
    int octave = form.octave ?? 4;

    octave -= 4;

    // TODO fix nullable
    return (form.step ?? Step.G).calculateX(-5) - ((octave * 41) + octave);
  }

  void _drawAttributes({
    required StaffPainterContext context,
    required Attributes attributes,
  }) {
    for (var clef in attributes.clefs) {
      if (clef.sign.smufl != null) {
        context.x += 10;

        drawSmuflSymbol(
          context.canvas,
          Offset(context.x, -5),
          clef.sign.smufl!,
        );
        context.x += 40;
      }
    }
    for (var key in attributes.keys) {
      switch (key) {
        case TraditionalKey _:
          break;
        case NonTraditionalKey _:
          break;
        default:
          break;
      }
    }
    for (var time in attributes.times) {
      switch (time) {
        case TimeBeat _:
          var signature = time.timeSignatures.firstOrNull;
          if (signature != null) {
            drawSmuflSymbol(
              context.canvas,
              Offset(context.x, (-staffHeight / 2) - 5),
              integerToSmufl(int.parse(signature.beats)),
            );
            drawSmuflSymbol(
              context.canvas,
              Offset(context.x, -5),
              integerToSmufl(int.parse(signature.beatType)),
            );

            context.x += 40;
          }
          break;
        case SenzaMisura _:
          break;
        default:
          break;
      }
    }
  }

  String integerToSmufl(int num) {
    final unicodeValue = 0xE080 + num;
    return String.fromCharCode(unicodeValue);
  }

  void _paintStaffLines(Canvas canvas, StaffPainterContext context) {
    var lineY = 0.0;
    for (var i = 0; i < _staffLines; i++) {
      canvas.drawLine(
        Offset(0, lineY),
        Offset(context.x, lineY),
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

    final borderRect = Rect.fromLTWH(
      offset.dx,
      offset.dy,
      textPainter.width + 8.0,
      textPainter.height + 8.0,
    );
    if (debugFrame) {
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

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class StaffPainterContext {
  double x = 0;

  final Canvas canvas;
  final Size size;

  StaffPainterContext({required this.canvas, required this.size});
}

extension NoteHeadSmufl on NoteTypeValue {
  static const _smuflSymbols = {
    NoteTypeValue.n1024th: '\uE0A4',
    NoteTypeValue.n512th: '\uE0A4',
    NoteTypeValue.n256th: '\uE0A4',
    NoteTypeValue.n128th: '\uE0A4',
    NoteTypeValue.n64th: '\uE0A4',
    NoteTypeValue.n32nd: '\uE0A4',
    NoteTypeValue.n16th: '\uE0A4',
    NoteTypeValue.eighth: '\uE0A4',
    NoteTypeValue.quarter: '\uE0A4',
    NoteTypeValue.half: '\uE0A3',
    NoteTypeValue.whole: '\uE0A2',
    NoteTypeValue.breve: '\uE0A0',
    NoteTypeValue.long: '\uE0A1',
    NoteTypeValue.maxima: '\uE0A1',
  };

  static String getSmuflSymbol(NoteTypeValue noteTypeValue) {
    return _smuflSymbols[noteTypeValue]!;
  }
}

extension SymbolPosition on Step {
  double calculateX(int startingX) {
    switch (this) {
      case Step.B:
        return (startingX * 3) - 2;
      case Step.A:
        return (startingX * 2) - 1;
      case Step.G:
        return (startingX * 1);
      case Step.F:
        return (startingX * 0) + 1;
      case Step.E:
        return (startingX * -2) - 3;
      case Step.D:
        return (startingX * -3) - 2;
      case Step.C:
        return (startingX * -4) - 1;
    }
  }

  int get numerical {
    switch (this) {
      case Step.B:
        return 6;
      case Step.A:
        return 5;
      case Step.G:
        return 4;
      case Step.F:
        return 3;
      case Step.E:
        return 2;
      case Step.D:
        return 1;
      case Step.C:
        return 0;
    }
  }

  int position(int octave) => (octave * 7) + numerical;
}

enum LedgerPlacement {
  above,
  below;
}
