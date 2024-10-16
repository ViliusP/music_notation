import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

/// A widget for synchronizing the width of children inside rows.
/// Each child width is based on the maximum width child for the corresponding position
/// across all rows. This is particularly useful for creating grid or table layouts
/// where columns should align by width even if the children have varying widths.
///
/// Usage:
/// ```dart
/// SyncWidthColumn(
///   children: [
///     Row(children: [Text('Short'), Text('Example'), Text('Test')]),
///     Row(children: [Text('This is a much longer text'), Text('Text2'), Text('Test3')]),
///     Row(children: [Text('Medium'), Text('Another Text'), Text('Test4')]),
///   ],
/// )
/// ```
///
/// How It Works:
/// 1. **Initialization**: A set of `GlobalKeys` is created for each widget in every row.
///    This helps in obtaining the actual width of the widget after it's rendered.
///
/// 2. **Measurement Phase**: After the initial render, the children's widths are measured
///    using the attached `GlobalKeys`.
///
/// 3. **Aggregation**: The maximum width for each "column" is determined based on the measured widths.
///    This operation has been optimized to reduce unnecessary UI rebuilds.
///
/// 4. **Layout Phase**: In the subsequent rendering pass, the maximum width calculated for each column is
///    applied to each child in that column to ensure consistent width across rows.
///
/// Private Components:
/// - `_SyncWidthColumnState`: The state associated with `SyncWidthColumn`, managing the width synchronization logic.
/// - `_SyncWidthRow`: A helper widget to simplify the building of each row in `SyncWidthColumn`.
///
/// Note: This widget is best suited for relatively static content where the cost of an additional layout pass
///       (measure and layout) can be afforded. For dynamic content or high-frequency layout changes,
///       consider an alternative approach or ensure performance benchmarks are satisfactory.
class SyncWidthColumn extends StatefulWidget {
  final List<SyncWidthRowBuilder> builders;

  const SyncWidthColumn({
    super.key,
    required this.builders,
  });

  @override
  State createState() => _SyncWidthColumnState();
}

class _SyncWidthColumnState extends State<SyncWidthColumn> {
  List<double?> maxColumnWidths = [];
  late List<List<GlobalKey>> rowsKeys;
  bool inMeasurementPass = true;

  @override
  void initState() {
    super.initState();
    initializeRowAndColumnData();
    scheduleMaxWidthsUpdate();
  }

  void initializeRowAndColumnData() {
    var rows = widget.builders.map((b) => b.children).toList();
    int maxColumns = rows.fold<int>(
      0,
      (prev, row) => max(prev, row.length),
    );

    maxColumnWidths = List.filled(maxColumns, null);
    rowsKeys = List.generate(
      rows.length,
      (_) => List.generate(maxColumns, (_) => GlobalKey()),
    );
  }

  void scheduleMaxWidthsUpdate() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateMaxWidths();
      if (mounted) {
        setState(() {
          inMeasurementPass = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: widget.builders.mapIndexed((i, rowBuilder) {
        List<Widget> buildedChildren = [];
        for (int j = 0; j < rowBuilder.children.length; j++) {
          buildedChildren.add(_buildRowElement(
            maxColumnWidth: maxColumnWidths[j],
            childKey: rowsKeys[i][j],
            child: rowBuilder.children[j],
          ));
        }
        return rowBuilder.builder(context, buildedChildren);
      }).toList(),
    );
  }

  Widget _buildRowElement({
    required double? maxColumnWidth,
    required GlobalKey childKey,
    required Widget child,
  }) {
    if (inMeasurementPass) {
      return Container(key: childKey, child: child);
    }
    return SizedBox(width: maxColumnWidth, child: child);
  }

  void updateMaxWidths() {
    var rows = widget.builders.map((b) => b.children).toList();

    for (int row = 0; row < rows.length; row++) {
      for (int col = 0; col < rows[row].length; col++) {
        final size = _getWidgetSize(rowsKeys[row][col]);
        if (size != null) {
          maxColumnWidths[col] = max(
            size.width,
            maxColumnWidths[col] ?? 0,
          );
        }
      }
    }
  }

  Size? _getWidgetSize(GlobalKey key) {
    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    return renderBox?.size;
  }
}

class SyncWidthRowBuilder extends StatelessWidget {
  final List<Widget> children;
  final Widget Function(BuildContext, List<Widget>) builder;

  const SyncWidthRowBuilder({
    super.key,
    required this.builder,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return builder(context, children);
  }
}
