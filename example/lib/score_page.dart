import 'package:flutter/material.dart';
import 'package:music_notation/music_notation.dart';
import 'package:collection/collection.dart';

class ScorePage extends StatefulWidget {
  final ScorePartwise scorePartwise;

  const ScorePage({super.key, required this.scorePartwise});

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
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
          child: MusicNotationCanvas(
            scorePartwise: widget.scorePartwise,
          ),
        ),
      ),
    );
  }
}
