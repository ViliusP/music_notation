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
  Size? size(GlyphBBox? bBoxes) {
    if (bBoxes == null) {
      return Size.infinite;
    }
    double width = (bBoxes.bBoxNE.x * 20 - bBoxes.bBoxSW.x * 20).abs();
    double height = (bBoxes.bBoxNE.y * 20 - bBoxes.bBoxSW.y * 20).abs();

    return Size(width, height);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(64.0),
      child: Stack(
        fit: StackFit.loose,
        children: [
          CustomPaint(
            size: Size(1400, 80),
            painter: StaffPainter(),
          ),
          ...glyphs.mapIndexed(
            (i, g) => Positioned(
              left: (i * 200) + 50,
              top: 40 - (bBoxes.elementAt(i)!.bBoxNE.y * 20).floorToDouble(),
              child: SizedBox.fromSize(
                size: size(bBoxes.elementAt(i)),
                child: CustomPaint(
                  painter: SmuflPainter(g, bBoxes.elementAt(i)!),
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
  SmuflGlyph.accidentalSharp,
  SmuflGlyph.restWhole,
  SmuflGlyph.restQuarter,
  SmuflGlyph.restWholeLegerLine,
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
  ),
  GlyphBBox(
    bBoxNE: Coordinates(x: 0.976, y: 1.336),
    bBoxSW: Coordinates(x: 0.0, y: -1.332),
  ),
  GlyphBBox(
    bBoxNE: Coordinates(x: 1.3, y: 0.02),
    bBoxSW: Coordinates(x: 0.0, y: -0.524),
  ),
  GlyphBBox(
    bBoxNE: Coordinates(x: 0.94, y: 1.604),
    bBoxSW: Coordinates(x: 0.0, y: -1.324),
  ),
  GlyphBBox(
    bBoxNE: Coordinates(x: 1.856, y: 0.056),
    bBoxSW: Coordinates(x: -0.556, y: -0.488),
  ),
];
