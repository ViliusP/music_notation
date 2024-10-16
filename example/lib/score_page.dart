import 'package:example/grid_debug.dart';
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
    ScoreHeader scoreHeader = widget.scorePartwise.scoreHeader;
    String? movementTitle = scoreHeader.movementTitle;
    String? creator = scoreHeader.identification?.creators
        ?.firstWhereOrNull((element) => element.type == "composer")
        ?.value;

    String title = "${creator ?? 'No creator'}: ${movementTitle ?? 'unnamed'}";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_alert),
            tooltip: 'Show Snackbar',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => GridDebug(score: widget.scorePartwise),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        child: MusicNotationCanvas(
          scorePartwise: widget.scorePartwise,
        ),
      ),
    );
  }
}
