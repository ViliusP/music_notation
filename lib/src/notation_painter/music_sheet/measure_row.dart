import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:music_notation/src/notation_painter/measure/measure_element.dart';
import 'package:music_notation/src/notation_painter/music_sheet/music_element.dart';
import 'package:music_notation/src/notation_painter/properties/layout_properties.dart';
import 'package:music_notation/src/notation_painter/properties/notation_properties.dart';
import 'package:music_notation/src/notation_painter/utilities/size_extensions.dart';

class MeasureRow extends StatelessWidget {
  final List<MeasureWidget> children;
  final double spaceBetween;
  final bool strictlyBounded;

  const MeasureRow({
    super.key,
    required this.children,
    this.spaceBetween = 0,
    this.strictlyBounded = false,
  });

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) {
      return SizedBox.shrink();
    }
    NotationLayoutProperties layoutProperties =
        NotationProperties.of(context)?.layout ??
            NotationLayoutProperties.standard();

    return CustomMultiChildLayout(
      delegate: _MeasureRowDelegate(
        children: children,
        strictlyBounded: strictlyBounded,
        spaceBetween: spaceBetween,
        scale: layoutProperties.staveSpace,
      ),
      children: [
        for (int i = 0; i < children.length; i++)
          LayoutId(id: i, child: children[i]),
      ],
    );
  }
}

class _MeasureRowDelegate extends MultiChildLayoutDelegate {
  final List<MeasureWidget> children;
  final bool strictlyBounded;
  final double spaceBetween;
  final double scale;

  _MeasureRowDelegate({
    required this.children,
    required this.scale,
    this.spaceBetween = 0,
    this.strictlyBounded = false,
  });

  @override
  void performLayout(Size size) {
    double left = 0;

    double maxOverflow = 0;
    List<double> lefts = [];
    for (int i = 0; i < children.length; i++) {
      lefts.add(left);
      final child = children[i];
      final childSize = layoutChild(
        i,
        BoxConstraints.loose(child.size.scale(scale)),
      );
      left += childSize.width + spaceBetween * scale;

      double top = -child.distance(children.first, BoxSide.top);
      maxOverflow = [maxOverflow, -top].max;
    }

    for (int i = 0; i < children.length; i++) {
      final child = children[i];
      double top = -child.distance(children.first, BoxSide.top);
      top = top + maxOverflow.abs();
      top = top * scale;
      positionChild(i, Offset(lefts[i], top));
    }
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
    return true;
  }
}
