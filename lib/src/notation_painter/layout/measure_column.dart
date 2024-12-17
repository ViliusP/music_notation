import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:music_notation/music_notation.dart';
import 'package:music_notation/src/notation_painter/layout/measure_element.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/layout/positioning.dart';
import 'package:music_notation/src/notation_painter/utilities/size_extensions.dart';

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
  AlignmentOffset get offset {
    if (_reference == null) return AlignmentOffset.zero();
    return AlignmentOffset.fromBottom(
      left: 0,
      bottom: _reference!.offset.bottom,
      height: size.height,
    );
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
    var range = MeasureElementLayoutData.columnVerticalRange(children);
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
      delegate: _MeasureColumnDelegate(
        children: children,
        strictlyBounded: true,
        scale: layoutProperties.staveSpace,
      ),
      children: [
        for (int i = 0; i < children.length; i++)
          LayoutId(id: i, child: children[i]),
      ],
    );
  }
}

class _MeasureColumnDelegate extends MultiChildLayoutDelegate {
  final List<MeasureWidget> children;
  final bool strictlyBounded;
  final double scale;

  _MeasureColumnDelegate({
    required this.children,
    required this.scale,
    this.strictlyBounded = false,
  });

  @override
  void performLayout(Size size) {
    MeasureElementLayoutData reference =
        children.sorted((a, b) => a.position.compareTo(b.position)).last;
    for (int i = 0; i < children.length; i++) {
      final child = children[i];

      layoutChild(i, BoxConstraints.loose(child.size.scale(scale)));

      double top = -child.distance(reference, BoxSide.top) * scale;

      positionChild(i, Offset(0, top));
    }
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
    return true;
  }
}

class MeasureParentData extends ContainerBoxParentData<RenderBox> {
  ElementPosition? position;

  AlignmentOffset? alignment;

  bool get isPositioned => position != null;
}

class MeasureColumnV2 extends MultiChildRenderObjectWidget {
  // final PositionalRange? range;
  final bool debug;
  final String debugName;

  final bool strictBounds;
  const MeasureColumnV2({
    super.key,
    // this.range,
    required super.children,
    this.debug = false,
    this.debugName = "",
    this.strictBounds = true,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    NotationLayoutProperties layoutProperties =
        NotationProperties.of(context)?.layout ??
            NotationLayoutProperties.standard();

    return RenderMeasureColumn(
      heightPerPosition: layoutProperties.spacePerPosition,
      debug: debug,
      debugName: debugName,
      strictBounds: strictBounds,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderMeasureColumn renderObject,
  ) {
    NotationLayoutProperties layoutProperties =
        NotationProperties.of(context)?.layout ??
            NotationLayoutProperties.standard();

    renderObject.debug = debug;
    renderObject.debugName = debugName;
    renderObject.heightPerPosition = layoutProperties.spacePerPosition;
    renderObject.strictBounds = strictBounds;
    // renderObject.positionlessAlignAtTop =
  }
}

abstract class RenderMeasureLayout extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, MeasureParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, MeasureParentData> {
  double heightPerPosition;
  double get _staveSpace => heightPerPosition * 2;

  RenderMeasureLayout({
    required this.heightPerPosition,
  });
}

class RenderMeasureColumn extends RenderMeasureLayout {
  bool debug;
  String debugName;
  bool strictBounds;

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! MeasureParentData) {
      child.parentData = MeasureParentData();
    }
  }

  void _log(Object? object) {
    if (debug) {
      // ignore: avoid_print
      print("$debugName: ${object.toString()}");
    }
  }

  bool positionlessAlignAtTop = true;

  RenderMeasureColumn({
    required super.heightPerPosition,
    required this.strictBounds,
    this.debug = false,
    this.debugName = "",
  });

  List<MeasureElementLayoutData?> _computePositionedData({
    required ChildLayouter layoutChild,
  }) {
    if (childCount == 0) return [];

    List<MeasureElementLayoutData?> data = [];

    RenderBox? child = firstChild;
    while (child != null) {
      final MeasureParentData childParentData =
          child.parentData! as MeasureParentData;

      final Size childSize = layoutChild(
        child,
        BoxConstraints(minHeight: 0, minWidth: 0),
      );

      if (childParentData.isPositioned) {
        data.add(MeasureElementLayoutData(
          position: childParentData.position!,
          size: childSize.scale(1 / _staveSpace),
          offset: childParentData.alignment ?? AlignmentOffset.zero(),
        ));
      } else {
        data.add(null);
      }
      child = childParentData.nextSibling;
    }
    return data;
  }

  double _computeHeightByPositioned(List<MeasureElementLayoutData> data) {
    // Distance between lowest element bottom side and highest element top side.
    // In stave spaces.
    var height = switch (strictBounds) {
      true => MeasureElementLayoutData.columnVerticalRange(data).distance,
      false => MeasureElementLayoutData.columnPositionalBounds(data)!.distance,
    };

    height = switch (strictBounds) {
      true => height * _staveSpace,
      false => height * heightPerPosition,
    };

    return height.toDouble();
  }

  ({ElementPosition position, double top}) _computeReference(
    List<MeasureElementLayoutData> data,
  ) {
    ElementPosition max = switch (strictBounds) {
      true => MeasureElementLayoutData.columnPositionalRange(data)!.max,
      false => MeasureElementLayoutData.columnPositionalBounds(data)!.max,
    };

    var top = switch (strictBounds) {
      true => data
          .sorted((a, b) => a.bounds.max.compareTo(b.bounds.max))
          .last
          .offset
          .top,
      false => 0.0,
    };

    return (position: max, top: top);
  }

  double _computeWidthByPositioned(List<MeasureElementLayoutData> data) {
    assert(data.isNotEmpty);

    double maxWidth = 0;

    for (var entry in data) {
      double width = entry.size.width;
      double maybeInfinity = (width * _staveSpace * 1.01);
      bool isInfinitive = maybeInfinity.isInfinite || width.isInfinite;
      if (!isInfinitive) {
        maxWidth = max(entry.size.width, maxWidth);
      }
    }
    return maxWidth * _staveSpace;
  }

  Size _computeSizeByPositioned(List<MeasureElementLayoutData> data) {
    return Size(
      _computeWidthByPositioned(data),
      _computeHeightByPositioned(data),
    );
  }

  Size _computeSize(List<MeasureElementLayoutData?> data) {
    var nonNull = data.nonNulls.toList();
    if (nonNull.isNotEmpty) {
      return _computeSizeByPositioned(nonNull);
    }
    return size = _computeSizeByNonPositioned(
      constraints: constraints,
      layoutChild: ChildLayoutHelper.dryLayoutChild,
    );
  }

  Size _computeSizeByNonPositioned({
    required BoxConstraints constraints,
    required ChildLayouter layoutChild,
  }) {
    if (childCount == 0) {
      return (constraints.biggest.isFinite) ? Size.zero : constraints.smallest;
    }

    double width = constraints.minWidth;
    double height = constraints.minHeight;

    RenderBox? child = firstChild;
    while (child != null) {
      final MeasureParentData childParentData =
          child.parentData! as MeasureParentData;

      if (!childParentData.isPositioned) {
        final Size childSize = child.size;

        if (childSize.width.isFinite) {
          width = max(width, childSize.width);
        }

        if (childSize.height.isFinite) {
          height = max(height, childSize.height);
        }
      }

      child = childParentData.nextSibling;
    }

    // assert(size.isFinite);
    return Size(width, height);
  }

  @override
  Size computeDryLayout(covariant BoxConstraints constraints) {
    var positionedData = _computePositionedData(
      layoutChild: ChildLayoutHelper.dryLayoutChild,
    );

    return _computeSize(positionedData);
  }

  @override
  void performLayout() {
    assert(() {
      RenderBox? child = firstChild;
      while (child != null) {
        if (child.parentData is! MeasureParentData) {
          throw FlutterError(
            'Children of MeasureLayoutV2 must have MeasureStackParentData. '
            'Wrap children in MeasureStack or MeasurePositioned widgets.',
          );
        }
        child = (child.parentData as MeasureParentData).nextSibling;
      }
      return true;
    }());
    final BoxConstraints constraints = this.constraints;
    var positionedData = _computePositionedData(
      layoutChild: ChildLayoutHelper.layoutChild,
    );
    var nonNullData = positionedData.nonNulls.toList();
    size = constraints.constrain(_computeSize(positionedData));

    bool hasPositioned = nonNullData.isNotEmpty;
    if (hasPositioned) {
      var reference = _computeReference(nonNullData);

      // If child has parentData as MeasureParentData,
      // it means it is child of RenderMeasureStack
      if (parentData is MeasureParentData) {
        (parentData as MeasureParentData).position = reference.position;
        (parentData as MeasureParentData).alignment = AlignmentOffset.fromTop(
          left: 0,
          top: reference.top,
          height: size.height / _staveSpace,
        );
      }
      _layoutChildren(
        data: positionedData,
        reference: reference.position,
        top: reference.top,
        size: size,
      );
    } else {
      _layoutNonPositioned(size);
      if (parentData is MeasureParentData) {
        (parentData as MeasureParentData).alignment = null;
        (parentData as MeasureParentData).position = null;
      }
    }
  }

  void _layoutNonPositioned(Size size) {
    RenderBox? child = firstChild;
    while (child != null) {
      final childParentData = child.parentData as MeasureParentData;
      child.layout(BoxConstraints.loose(size), parentUsesSize: true);
      childParentData.offset = Offset(0, 0);
      child = childParentData.nextSibling;
    }
  }

  void _layoutChildren({
    required List<MeasureElementLayoutData?> data,
    required ElementPosition reference,
    required double top,
    required Size size,
  }) {
    int i = 0;
    RenderBox? child = firstChild;
    while (child != null) {
      final childParentData = child.parentData as MeasureParentData;

      var positionalData = data.elementAt(i);
      if (positionalData == null) {
        child.layout(BoxConstraints.loose(size), parentUsesSize: true);
        childParentData.offset = Offset(0, 0);
      }

      if (positionalData != null) {
        child.layout(BoxConstraints.loose(size), parentUsesSize: true);
        double y = positionalData.distanceToPosition(reference, BoxSide.top);
        // Strict bounds means that top element will have negative Y,
        // so we need to shift every element by that top element's top offset.
        y = y + top;
        y = -y * _staveSpace;

        Offset offset = Offset(0, y);

        childParentData.offset = offset;
      }
      child = childParentData.nextSibling;
      i++;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    RenderBox? child = firstChild;
    while (child != null) {
      final childParentData = child.parentData as MeasureParentData;
      context.paintChild(child, offset + childParentData.offset);
      child = childParentData.nextSibling;
    }
  }
}
