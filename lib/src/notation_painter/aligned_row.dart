import 'dart:math';

import 'package:flutter/material.dart';

class Offsetted extends StatelessWidget {
  final Widget child;
  final double offset;

  const Offsetted({
    super.key,
    required this.child,
    this.offset = 0.0,
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

    // First pass: Measure all children and determine the necessary adjustments.
    List<Size> sizes = [];
    for (int i = 0; i < children.length; i++) {
      final child = children[i];
      double offset = 0;

      if (child is Offsetted) {
        offset = child.offset;

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
        final overflow = offset + childSize.height - size.height;
        maxPositiveOverflow = max(overflow, maxPositiveOverflow);
      }
    }

    // Second pass: Position children with calculated adjustments.
    for (int i = 0; i < children.length; i++) {
      final child = children[i];
      double offset = 0;

      if (child is Offsetted) {
        offset = child.offset;

        // Handle negative offset logic for bottom alignment.
        if (alignment == VerticalAlignment.bottom) {
          offset = -offset;
        }
      }

      double top = offset;

      if (alignment == VerticalAlignment.top) {
        // Shift all children down by the largest negative offset (make top non-negative).
        top += -maxNegativeOffset;
      } else if (alignment == VerticalAlignment.bottom) {
        top -= maxPositiveOverflow + sizes[i].height - size.height;
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
