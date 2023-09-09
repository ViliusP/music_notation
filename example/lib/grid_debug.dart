import 'package:example/measure_grid_debug.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:music_notation/music_notation.dart';

class GridDebug extends StatelessWidget {
  final ScorePartwise score;
  NotationGrid get notationGrid => NotationGrid.fromScoreParts(score.parts);

  const GridDebug({
    super.key,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug: notation grid'),
      ),
      body: ScrollConfiguration(
        behavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.mouse,
            PointerDeviceKind.touch,
            PointerDeviceKind.stylus,
            PointerDeviceKind.unknown
          },
        ),
        child: Column(),
        // child: Column(
        //   children: notationGrid.data
        //       .mapIndexed((partIndex, part) => SizedBox(
        //             height: 120,
        //             child: ListView(
        //               // This next line does the trick.
        //               scrollDirection: Axis.horizontal,
        //               children: part
        //                   .mapIndexed((index, measure) => Padding(
        //                         padding: const EdgeInsets.all(8.0),
        //                         child: SizedBox(
        //                           height: 120,
        //                           width: 120,
        //                           child: _MeasureGrid(
        //                             sequence: MeasureSequence.fromMeasure(
        //                               measure: measure,
        //                             ),
        //                             partIndex: partIndex,
        //                             measureIndex: index,
        //                           ),
        //                         ),
        //                       ))
        //                   .toList(),
        //             ),
        //           ))
        //       .toList(),
        // ),
      ),
    );
  }
}

class _MeasureGrid extends StatelessWidget {
  final int measureIndex;
  final int partIndex;

  const _MeasureGrid({
    super.key,
    required this.measureIndex,
    required this.partIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.antiAlias,
      color: Colors.amber,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 3,
      child: InkWell(
        splashColor: Colors.amberAccent,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MeasureGridDebug(
                measureNumber: measureIndex,
                partNumber: partIndex,
              ),
            ),
          );
        },
        child: Center(
          child: Text(
            "$partIndex.$measureIndex",
            style: const TextStyle(fontSize: 36),
          ),
        ),
      ),
    );
  }
}
