import 'dart:math';

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
      child: Column(
        children: [
          Stack(
            fit: StackFit.loose,
            children: [
              CustomPaint(
                size: Size(1400, 80),
                painter: StaffPainter(),
              ),
              ...glyphs.mapIndexed(
                (i, g) => Positioned(
                  left: (i * 200) + 50,
                  top:
                      40 - (bBoxes.elementAt(i)!.bBoxNE.y * 20).floorToDouble(),
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
  SmuflGlyph.augmentationDot,
];

List<GlyphBBox?> bBoxes = [
  GlyphBBox(
    bBoxNE: Point<double>(2.556, 4.448),
    bBoxSW: Point<double>(0.0, -2.664),
  ),
  GlyphBBox(
    bBoxNE: Point<double>(1.3, 0.528),
    bBoxSW: Point<double>(0.0, -0.532),
  ),
  GlyphBBox(
    bBoxNE: Point<double>(0.812, 1.812),
    bBoxSW: Point<double>(0.0, -0.704),
  ),
  GlyphBBox(
    bBoxNE: Point<double>(0.976, 1.336),
    bBoxSW: Point<double>(0.0, -1.332),
  ),
  GlyphBBox(
    bBoxNE: Point<double>(1.3, 0.02),
    bBoxSW: Point<double>(0.0, -0.524),
  ),
  GlyphBBox(
    bBoxNE: Point<double>(0.94, 1.604),
    bBoxSW: Point<double>(0.0, -1.324),
  ),
  GlyphBBox(
    bBoxNE: Point<double>(1.856, 0.056),
    bBoxSW: Point<double>(-0.556, -0.488),
  ),
  GlyphBBox(
    bBoxNE: Point<double>(0.4, 0.2),
    bBoxSW: Point<double>(0, -0.196),
  ),
];
