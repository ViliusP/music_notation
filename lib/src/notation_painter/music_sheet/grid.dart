import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class TargetOffsetRenderBox extends RenderProxyBox {
  double targetOffset = 0.0; // Offset of the target sub-widget

  @override
  void performLayout() {
    if (child != null) {
      child!.layout(constraints, parentUsesSize: true);
      size = child!.size;

      // Find the target sub-widget's offset
      targetOffset = _findTargetOffset(child!);
    } else {
      size = constraints.smallest;
    }
  }

  double _findTargetOffset(RenderObject renderObject) {
    if (renderObject is TargetRenderBox) {
      // Found the target, return its offset relative to this render object
      final Matrix4 transform = renderObject.getTransformTo(this);
      final Offset? offset = MatrixUtils.getAsTranslation(transform);
      if (offset != null) {
        return offset.dy;
      } else {
        // Handle cases where the transform includes scaling or rotation
        return transform.getTranslation().y;
      }
    } else if (renderObject is RenderProxyBox) {
      // Recurse into child
      if (renderObject.child != null) {
        return _findTargetOffset(renderObject.child!);
      }
    } else if (renderObject is RenderObjectWithChildMixin) {
      // Recurse into child
      final child = renderObject.child;
      if (child != null) {
        return _findTargetOffset(child);
      }
    } else if (renderObject is ContainerRenderObjectMixin) {
      // Recurse into children
      double offset = 0.0;
      bool found = false;
      renderObject.visitChildren((RenderObject child) {
        if (!found) {
          final childOffset = _findTargetOffset(child);
          if (childOffset != 0.0) {
            offset = childOffset;
            found = true;
          }
        }
      });
      return offset;
    }
    return 0.0;
  }
}

class _AlignedChild extends SingleChildRenderObjectWidget {
  const _AlignedChild(Widget child) : super(child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return TargetOffsetRenderBox();
  }
}

class AlignTarget extends SingleChildRenderObjectWidget {
  const AlignTarget({super.key, super.child});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return TargetRenderBox();
  }
}

class TargetRenderBox extends RenderProxyBox {}

class AlignedRowRenderObject extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, AlignedRowParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, AlignedRowParentData> {
  @override
  void performLayout() {
    double maxTargetOffset = 0.0;
    double totalWidth = 0.0;

    // First pass: Layout children and find the maximum target offset
    RenderBox? child = firstChild;
    while (child != null) {
      final AlignedRowParentData childParentData =
          child.parentData as AlignedRowParentData;

      child.layout(constraints, parentUsesSize: true);

      // Get the target offset from child
      if (child is TargetOffsetRenderBox) {
        double childTargetOffset = child.targetOffset;
        childParentData.targetOffset = childTargetOffset;

        if (childTargetOffset > maxTargetOffset) {
          maxTargetOffset = childTargetOffset;
        }
      }

      totalWidth += child.size.width;

      child = childParentData.nextSibling;
    }

    // Second pass: Position children so that their target offsets align
    double xPosition = 0.0;
    double minY = double.infinity;
    double maxY = double.negativeInfinity;

    child = firstChild;
    while (child != null) {
      final AlignedRowParentData childParentData =
          child.parentData as AlignedRowParentData;

      double shift = maxTargetOffset - childParentData.targetOffset;
      childParentData.offset = Offset(xPosition, shift);

      // Update minY and maxY based on shifted positions
      double childTop = shift;
      double childBottom = shift + child.size.height;

      if (childTop < minY) {
        minY = childTop;
      }
      if (childBottom > maxY) {
        maxY = childBottom;
      }

      xPosition += child.size.width;

      child = childParentData.nextSibling;
    }

    // Adjust the offsets if necessary
    double totalHeight = maxY - minY;

    // If minY is negative, shift all children down
    if (minY < 0) {
      child = firstChild;
      while (child != null) {
        final AlignedRowParentData childParentData =
            child.parentData as AlignedRowParentData;

        childParentData.offset = childParentData.offset.translate(0, -minY);

        child = childParentData.nextSibling;
      }
      minY = 0;
      maxY = totalHeight;
    }

    size = constraints.constrain(Size(totalWidth, totalHeight));
  }

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! AlignedRowParentData) {
      child.parentData = AlignedRowParentData();
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }
}

class AlignedRow extends MultiChildRenderObjectWidget {
  AlignedRow({super.key, required List<Widget> children})
      : super(
          children: children.map((child) => _AlignedChild(child)).toList(),
        );

  @override
  RenderObject createRenderObject(BuildContext context) {
    return AlignedRowRenderObject();
  }
}

class AlignedRowParentData extends ContainerBoxParentData<RenderBox> {
  double targetOffset = 0.0; // Offset of the target sub-widget inside the child
}
