import 'dart:math';

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
  late List<List<GlobalKey>> rowKeys;
  bool inMeasurementPass = true;

  @override
  void initState() {
    super.initState();
    initializeRowAndColumnData();
    scheduleMaxWidthsUpdate();
  }

  void initializeRowAndColumnData() {
    List<Row> rows = widget.builders.map((b) => b.child).toList();
    int maxColumns = rows.fold<int>(
      0,
      (prev, row) => max(prev, row.children.length),
    );

    maxColumnWidths = List.filled(maxColumns, null);
    rowKeys = List.generate(
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
    List<Row> rows = widget.builders.map((b) => b.child).toList();

    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.builders.length,
      itemBuilder: (context, i) {
        return widget.builders[i].builder(
          context,
          _SyncWidthRow(
            maxColumnWidths: maxColumnWidths,
            rowKeys: rowKeys[i],
            inMeasurementPass: inMeasurementPass,
            children: rows[i].children,
          ),
        );
      },
    );
  }

  void updateMaxWidths() {
    List<Row> rows = widget.builders.map((b) => b.child).toList();

    for (int rowIndex = 0; rowIndex < rows.length; rowIndex++) {
      for (int colIndex = 0;
          colIndex < rows[rowIndex].children.length;
          colIndex++) {
        final size = _getWidgetSize(rowKeys[rowIndex][colIndex]);
        if (size != null) {
          maxColumnWidths[colIndex] = max(
            size.width,
            maxColumnWidths[colIndex] ?? 0,
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

class _SyncWidthRow extends StatelessWidget {
  final List<Widget> children;
  final List<double?> maxColumnWidths;
  final List<GlobalKey> rowKeys;
  final bool inMeasurementPass;

  const _SyncWidthRow({
    required this.children,
    required this.maxColumnWidths,
    required this.rowKeys,
    required this.inMeasurementPass,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var colIndex = 0; colIndex < children.length; colIndex++)
          ..._buildColumnContent(colIndex)
      ],
    );
  }

  List<Widget> _buildColumnContent(int colIndex) {
    if (inMeasurementPass) {
      return [Container(key: rowKeys[colIndex], child: children[colIndex])];
    }
    return [
      SizedBox(width: maxColumnWidths[colIndex], child: children[colIndex])
    ];
  }
}

class SyncWidthRowBuilder extends StatelessWidget {
  final Row child;
  final Widget Function(BuildContext, Widget) builder;

  const SyncWidthRowBuilder({
    super.key,
    required this.builder,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return builder(context, child);
  }
}
