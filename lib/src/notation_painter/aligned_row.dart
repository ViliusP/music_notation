import 'dart:math';

import 'package:flutter/material.dart';

class Offsetted extends StatelessWidget {
  final Widget child;

  /// Values of [offset] for [AlignedRow] alignment axis.
  final Offset offset;

  const Offsetted({
    super.key,
    required this.child,
    this.offset = const Offset(0, 0),
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class Aligned extends StatelessWidget {
  final Widget child;

  final VerticalAlignment? alignment;

  const Aligned({
    super.key,
    required this.child,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

enum VerticalAlignment {
  top,
  bottom;
}

class AlignedRow extends StatelessWidget {
  final List<Widget> children;
  final VerticalAlignment alignment;

  const AlignedRow({
    super.key,
    required this.children,
    required this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return CustomMultiChildLayout(
      delegate: _CustomAlignedRowDelegate(
        children: children,
        alignment: alignment,
      ),
      children: [
        for (int i = 0; i < children.length; i++)
          LayoutId(
            id: i,
            child: children[i],
          ),
      ],
    );
  }
}

class _CustomAlignedRowDelegate extends MultiChildLayoutDelegate {
  final List<Widget> children;
  final VerticalAlignment alignment;

  _CustomAlignedRowDelegate({
    required this.children,
    required this.alignment,
  });

  @override
  void performLayout(Size size) {
    double left = 0;
    // Tracks the largest negative offset for top alignment.
    double maxNegativeOffset = 0;
    // Tracks the largest overflow for bottom alignment.
    double maxPositiveOverflow = 0;

    // -----------
    // First pass: Measure all children and determine the necessary adjustments.
    // -----------
    List<Size> sizes = [];
    for (int i = 0; i < children.length; i++) {
      final child = children[i];
      double offset = 0;

      if (child is Offsetted) {
        offset = child.offset.dy;

        // Handle negative offset logic for bottom alignment.
        if (alignment == VerticalAlignment.bottom) {
          offset = -offset;
        }
      }

      final childSize = layoutChild(i, BoxConstraints.loose(size));
      sizes.add(childSize);
      if (alignment == VerticalAlignment.top) {
        // Find the largest negative offset.
        maxNegativeOffset = min(offset, maxNegativeOffset);
      } else if (alignment == VerticalAlignment.bottom) {
        // Calculate how much the child would overflow below the parent's bottom.
        maxPositiveOverflow = max(offset, maxPositiveOverflow);
      }
    }
    // ------------
    // Second pass: Position children with calculated adjustments.
    // ------------
    for (int i = 0; i < children.length; i++) {
      final child = children[i];
      double offset = 0;

      if (child is Offsetted) {
        offset = child.offset.dy;
        left += child.offset.dx;

        // Handle negative offset logic for bottom alignment.
        if (alignment == VerticalAlignment.bottom) {
          offset = -offset;
        }
      }

      double top = 0;

      if (child is! Aligned) {
        switch (alignment) {
          case VerticalAlignment.top:
            top = offset;
            // Shift all children down by the largest negative offset (make top non-negative).
            top += -maxNegativeOffset;
            break;
          case VerticalAlignment.bottom:
            // Shift down child so it's bottom aligns with parent's bottom
            top += size.height - sizes[i].height;
            // Shift up child by overflow.
            top -= maxPositiveOverflow;
            top += offset;
            break;
        }
      }

      if (child is Aligned) {
        switch (child.alignment) {
          case VerticalAlignment.top:
            top = 0;
            break;
          case VerticalAlignment.bottom:
            top = size.height - sizes[i].height;
            break;
          case null:
            break;
        }
      }
      positionChild(i, Offset(left, top));
      left += sizes[i].width;
    }
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
    return true;
  }
}
