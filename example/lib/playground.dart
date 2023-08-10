import 'package:flutter/material.dart';
import 'package:music_notation/music_notation.dart';

class Playground extends StatelessWidget {
  const Playground({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Playground"),
      ),
      body: SyncWidthColumn(
        children: [
          ['Short', 'Example', 'Test'],
          ['This is a much longer text', 'Text2', 'Test3'],
          ['Medium', 'Another Text', 'Test4'],
        ]
            .map((row) => Row(
                  children: row.map((text) => Text(text)).toList(),
                ))
            .toList(),
      ),
    );
  }
}
