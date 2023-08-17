import 'package:flutter/material.dart';

import 'package:music_notation/music_notation.dart';

class MeasureGridDebug extends StatelessWidget {
  final int partNumber;
  final int measureNumber;

  const MeasureGridDebug({
    super.key,
    required this.partNumber,
    required this.measureNumber,
  });

  @override
  Widget build(BuildContext context) {
    // print(measure);
    return Scaffold(
      appBar: AppBar(
        title: Text("Debug: $partNumber.$measureNumber measure grid"),
      ),
      body: const SingleChildScrollView(
        child: Column(
            // children: sequence
            //     .map(
            //       (row) => Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: SizedBox(
            //           height: 140,
            //           width: MediaQuery.of(context).size.width,
            //           child: ListView(
            //             scrollDirection: Axis.horizontal,
            //             children: row
            //                 .map((cell) => Padding(
            //                       padding: const EdgeInsets.all(8.0),
            //                       child: SizedBox(
            //                         width: 120,
            //                         child: _VisualElementCard(
            //                           cell: cell,
            //                         ),
            //                       ),
            //                     ))
            //                 .toList(),
            //           ),
            //         ),
            //       ),
            //     )
            //     .toList(),
            ),
      ),
    );
  }
}

class _VisualElementCard extends StatelessWidget {
  final VisualMusicElement? cell;

  const _VisualElementCard({
    Key? key,
    required this.cell,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.pink,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            cell?.symbol ?? "-",
            style: const TextStyle(fontFamily: "Sebastian", fontSize: 28),
          ),
          const SizedBox(
            height: 8,
          ),
          cell?.symbol != null
              ? Text(
                  "${cell?.position}",
                  style: const TextStyle(fontSize: 20),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
