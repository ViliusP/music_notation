import 'package:flutter/material.dart';
import 'package:music_notation/music_notation.dart';

class ScorePage extends StatefulWidget {
  final ScorePartwise scorePartwise;

  const ScorePage({super.key, required this.scorePartwise});

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
