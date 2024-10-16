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
        body: SizedBox()
        //  SyncWidthColumn(
        //   children: [
        //     [
        //       'Short',
        //       'Example',
        //       'Test',
        //       "Long long long long text that shouldn't break because there are lots of unconstrained free space",
        //     ],
        //     [
        //       'This is a much longer text',
        //       'Text2',
        //       'Test3',
        //     ],
        //     [
        //       'Medium',
        //       'Another Text',
        //       'Test4',
        //       "Test4",
        //     ],
        //   ]
        //       .map((row) => Row(
        //             children: row.map((text) => Text(text)).toList(),
        //           ))
        //       .toList(),
        // ),
        );
  }
}
