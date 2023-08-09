import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Playground extends StatelessWidget {
  const Playground({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Playground"),
      ),
      body: SizedBox(height: 1000, width: 1000, child: LineAlignedRow()),
    );
  }
}

class LineAlignedRow extends StatelessWidget {
  // Sample alignments for demonstration. You can determine these programmatically based on your actual use case.
  final List<double> alignments = [0.2, -0.5, 0.7];

  @override
  Widget build(BuildContext context) {
    double maxAlignment = alignments
        .reduce((value, element) => value > element ? value : element);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: alignments.map((alignment) {
        return CustomStack(alignment: maxAlignment); // Use max alignment here
      }).toList(),
    );
  }
}

class CustomStack extends StatelessWidget {
  final double alignment;

  CustomStack({required this.alignment});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Other potential children go here...
        Container(
          width: 50,
          height: 50 + Random().nextDouble() * 100,
          color: Colors.red,
        ),
        Positioned(
          bottom: 50 + Random().nextDouble() * 100,
          child: Container(
            width: 50,
            height: 50 + Random().nextDouble() * 100,
            color: Colors.red,
          ),
        ),
        Align(
          alignment: Alignment(0, alignment),
          child: Container(
            width: 50, // Or any other width
            height: 3,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }
}
