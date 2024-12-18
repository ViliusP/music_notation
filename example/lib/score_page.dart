import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:music_notation/music_notation.dart';

class ScorePage extends StatefulWidget {
  final ScorePartwise scorePartwise;
  final String description;
  final FontMetadata? fontMetadata;
  final String? fontMetadataPath;

  const ScorePage({
    super.key,
    required this.scorePartwise,
    this.description = "",
    this.fontMetadata,
    this.fontMetadataPath,
  });

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  FontMetadata? font;
  static const _fontPath =
      'packages/music_notation/smufl_fonts/Leland/leland_metadata.json';

  @override
  void initState() {
    if (widget.fontMetadata == null) {
      rootBundle.loadString(widget.fontMetadataPath ?? _fontPath).then((x) {
        font = FontMetadata.fromJson(jsonDecode(x));
        setState(() {});
      });
    }
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

    FontMetadata? fontToUse = widget.fontMetadata ?? font;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.description.isNotEmpty)
            Padding(
              padding: EdgeInsets.all(16),
              child: MarkdownBody(
                data: widget.description,
              ),
            ),
          Scrollbar(
              controller: scorePageScrollController,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: scorePageScrollController,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                child: fontToUse == null
                    ? SizedBox.shrink()
                    : NotationProperties(
                        layout: NotationLayoutProperties(staveHeight: 60.9),
                        font: fontToUse,
                        child: MusicSheet.fromScore(
                          score: widget.scorePartwise,
                          font: fontToUse,
                        ),
                      ),
              )),
        ],
      ),
    );
  }
}
