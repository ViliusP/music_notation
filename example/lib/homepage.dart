import 'package:collection/collection.dart';
import 'package:example/music_painter_debug.dart';
import 'package:flutter/material.dart';
import 'package:music_notation/music_notation.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  double? calcWidth(GlyphBBox? bBoxes) {
    if (bBoxes == null) {
      return double.maxFinite;
    }
    return (bBoxes.bBoxNE.x * 20 - bBoxes.bBoxSW.x * 20).abs();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(64.0),
      child: Stack(
        fit: StackFit.loose,
        children: [
          CustomPaint(
            size: Size(1000, 80),
            painter: StaffPainter(),
          ),
          ...glyphs.mapIndexed(
            (i, g) => Positioned(
              left: (i * 200) + 50,
              child: SizedBox(
                height: 80,
                width: calcWidth(bBoxes.elementAt(i)),
                child: CustomPaint(
                  painter: SmuflPainter(g, bBoxes.elementAt(i)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

List<SmuflGlyph> glyphs = [
  SmuflGlyph.gClef,
  SmuflGlyph.noteheadBlack,
  SmuflGlyph.accidentalFlat,
];

List<GlyphBBox?> bBoxes = [
  GlyphBBox(
    bBoxNE: Coordinates(x: 2.556, y: 4.448),
    bBoxSW: Coordinates(x: 0.0, y: -2.664),
  ),
  GlyphBBox(
    bBoxNE: Coordinates(x: 1.3, y: 0.528),
    bBoxSW: Coordinates(x: 0.0, y: -0.532),
  ),
  GlyphBBox(
    bBoxNE: Coordinates(x: 0.812, y: 1.812),
    bBoxSW: Coordinates(x: 0.0, y: -0.704),
  )
];
