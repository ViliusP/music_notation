import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:music_notation/music_notation.dart';
import 'package:music_notation/src/notation_painter/measure/measure_element.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/models/range.dart';
import 'package:music_notation/src/notation_painter/utilities/size_extensions.dart';

typedef OffsetCalculator = double Function(MeasureElementData);

class MeasureParentData extends ContainerBoxParentData<RenderBox> {
  ElementPosition? position;

  AlignmentOffset? alignment;
}

class MeasureLayoutV2 extends MultiChildRenderObjectWidget {
  // final PositionalRange? range;
  final bool debug;
  final String debugName;

  final bool strictBounds;
  const MeasureLayoutV2({
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

    return RenderMeasureStack(
      heightPerPosition: layoutProperties.spacePerPosition,
      debug: debug,
      debugName: debugName,
      strictBounds: strictBounds,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderMeasureStack renderObject,
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

class RenderMeasureStack extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, MeasureParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, MeasureParentData> {
  double heightPerPosition;
  double get _staveSpace => heightPerPosition * 2;
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

  RenderMeasureStack({
    required this.heightPerPosition,
    required this.strictBounds,
    this.debug = false,
    this.debugName = "",
  });

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

    // ---------------
    // FIRST PASS
    // ---------------
    var measureElements = _layoutChildren();

    // ---------------
    // Ranges
    // ---------------
    var nonNullElements = measureElements.nonNulls.toList();

    PositionalRange? range = switch (strictBounds) {
      true => MeasurePositioned.columnPositionalRange(nonNullElements),
      false => MeasurePositioned.columnPositionalBounds(nonNullElements),
    };

    // Distance between lowest element bottom side and highest element top side.
    // In stave spaces.
    double? distance = switch (strictBounds) {
      true => MeasurePositioned.columnVerticalRange(nonNullElements).distance,
      false => range?.distance.toDouble(),
    };

    var topOffset = switch (strictBounds) {
      true => nonNullElements
          .sorted((a, b) => a.bounds.max.compareTo(b.bounds.max))
          .lastOrNull
          ?.offset
          .top,
      false => 0.0,
    };

    // ---------------
    // SECOND PASS
    // ---------------
    Size positionlessSize = _placePositionless(measureElements);

    Size? measureElementSize;
    if (range != null) {
      double width = _placeMeasureElements(
        measureElements,
        range.max,
        topOffset ?? 0,
      );

      double height = switch (strictBounds) {
        true => distance! * _staveSpace,
        false => distance! * heightPerPosition,
      };

      measureElementSize = Size(width, height);
    }

    // If child has parentData as MeasureParentData,
    // it means it is child of RenderMeasureStack
    if (parentData is MeasureParentData && range != null) {
      (parentData as MeasureParentData).position = range.max;
      (parentData as MeasureParentData).alignment = AlignmentOffset.fromTop(
        left: 0,
        top: topOffset ?? 0,
        height: measureElementSize!.height / _staveSpace,
      );
    } else if (parentData is MeasureParentData) {
      (parentData as MeasureParentData).alignment = null;
      (parentData as MeasureParentData).position = null;
    }

    size = constraints.constrain(measureElementSize ?? positionlessSize);
  }

  List<MeasureElementData?> _layoutChildren() {
    RenderBox? child = firstChild;

    List<MeasureElementData?> elements = [];

    while (child != null) {
      final childParentData = child.parentData as MeasureParentData;
      child.layout(
        BoxConstraints(minHeight: 0, minWidth: 0),
        parentUsesSize: true,
      );

      var position = childParentData.position;
      if (position == null) {
        elements.add(null);
      } else {
        elements.add(MeasureElementData(
          position: position,
          size: child.size.scale(1 / _staveSpace),
          offset: childParentData.alignment ?? AlignmentOffset.zero(),
          duration: 0,
        ));
      }

      _log("Child position ${childParentData.position}");
      child = childParentData.nextSibling;
    }
    return elements;
  }

  Size _placePositionless(List<MeasureElementData?> data) {
    double width = 0;
    double height = 0;

    int i = 0;
    RenderBox? child = firstChild;
    while (child != null) {
      final childParentData = child.parentData as MeasureParentData;
      if (data.elementAt(i) == null) {
        height = max(width, child.size.height);
        width = max(height, child.size.width);

        childParentData.offset = Offset(0, 0);
      }
      child = childParentData.nextSibling;
      i++;
    }

    return Size(width, height);
  }

  double _placeMeasureElements(
    List<MeasureElementData?> data,
    ElementPosition reference,
    double verticalOffset,
  ) {
    double width = 0;

    int i = 0;
    RenderBox? child = firstChild;
    while (child != null) {
      final childParentData = child.parentData as MeasureParentData;

      var positionalData = data.elementAt(i);
      if (positionalData != null) {
        double y = positionalData.distanceToPosition(reference, BoxSide.top);
        // Strict bounds means that top element will have negative Y,
        // so we need to shift every element by that top element's top offset.
        y = y + verticalOffset;
        y = -y * _staveSpace;

        width = max(width, child.size.width);
        Offset offset = Offset(0, y);

        childParentData.offset = offset;
      }
      child = childParentData.nextSibling;
      i++;
    }

    return width;
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
