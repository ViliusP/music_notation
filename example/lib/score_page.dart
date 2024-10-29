import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_notation/music_notation.dart';

class ScorePage extends StatefulWidget {
  final ScorePartwise scorePartwise;

  const ScorePage({super.key, required this.scorePartwise});

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  FontMetadata? font;
  static const _fontPath =
      'packages/music_notation/smufl_fonts/Leland/leland_metadata.json';

  @override
  void initState() {
    rootBundle.loadString(_fontPath).then((x) {
      font = FontMetadata.fromJson(jsonDecode(x));
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController scorePageScrollController = ScrollController();

    // ScoreHeader scoreHeader = widget.scorePartwise.scoreHeader;
    // String? movementTitle = scoreHeader.movementTitle;
    // String? creator = scoreHeader.identification?.creators
    //     ?.firstWhereOrNull((element) => element.type == "composer")
    //     ?.value;

    // String title = "${creator ?? 'No creator'}: ${movementTitle ?? 'unnamed'}";

    return Scrollbar(
      controller: scorePageScrollController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: scorePageScrollController,
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          child: font == null
              ? SizedBox.shrink()
              : MusicNotationCanvas(
                  scorePartwise: widget.scorePartwise,
                  font: font!,
                ),
        ),
      ),
    );
  }
}
