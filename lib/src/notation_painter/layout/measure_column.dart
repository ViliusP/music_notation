import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:music_notation/music_notation.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/layout/positioning.dart';

class MeasureColumn extends StatelessWidget implements MeasureWidget {
  final List<MeasureWidget> children;

  const MeasureColumn({
    super.key,
    required this.children,
  });

  @override
  ElementPosition get position =>
      _reference?.position ?? ElementPosition.staffMiddle;

  @override
  Alignment get alignment {
  }

  MeasureElementLayoutData? get _reference {
    if (children.isEmpty) return null;
    if (children.length == 1) return children.first;

    var sortedByBottom = children.sorted((a, b) {
      return a.bounds.min.compareTo(b.bounds.min);
    });

    /// Element with lowest bottom bound.
    return sortedByBottom.first;
  }

  @override
  Size get size {
    var heightPerPosition = NotationLayoutProperties.baseSpacePerPosition;

    var range = children.columnVerticalRange(heightPerPosition);
    double height = range.distance;

    double width = 0;
    for (var child in children) {
      width = max(width, child.size.width);
    }

    return Size(width, height);
  }

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) {
      return SizedBox.shrink();
    }
    NotationLayoutProperties layoutProperties =
        NotationProperties.of(context)?.layout ??
            NotationLayoutProperties.standard();

    return CustomMultiChildLayout(
      delegate: _MeasureColumnDelegate(children: children),
      children: [
        for (int i = 0; i < children.length; i++)
          LayoutId(id: i, child: children[i]),
      ],
    );
  }
}

class _MeasureColumnDelegate extends MultiChildLayoutDelegate {
  final List<MeasureWidget> children;

  _MeasureColumnDelegate({
    required this.children,
  });

  @override
  void performLayout(Size size) {
    double heightPerPosition = NotationLayoutProperties.baseSpacePerPosition;

    MeasureElementLayoutData reference =
        children.sorted((a, b) => a.position.compareTo(b.position)).last;
    for (int i = 0; i < children.length; i++) {
      final child = children[i];

      layoutChild(i, BoxConstraints.loose(child.size));

      double top = -child.distance(reference, BoxSide.top, heightPerPosition);

      positionChild(i, Offset(0, top));
    }
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
    return true;
  }
}
