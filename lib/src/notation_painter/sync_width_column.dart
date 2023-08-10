import 'package:flutter/widgets.dart';

/// `SyncWidthColumn`:
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
/// 2. **Measurement Phase**: In the first rendering pass, children are rendered without width constraints.
///    Their widths are then measured using the attached `GlobalKeys`.
///
/// 3. **Aggregation**: The maximum width for each "column" is determined based on the measured widths.
///
/// 4. **Layout Phase**: In the second rendering pass, the maximum width calculated for each column is applied to
///    each child in that column to ensure consistent width across rows.
///
/// Private Components:
/// - `_SyncWidthColumnState`: The state associated with `SyncWidthColumn`, managing the width synchronization logic.
/// - `_SyncWidthRow`: A helper widget to simplify the building of each row in `SyncWidthColumn`.
///
/// Note: This widget is best suited for relatively static content where the cost of double layout pass
///       (measure and layout) can be afforded. For dynamic content or high-frequency layout changes,
///       consider an alternative approach or ensure performance benchmarks are satisfactory.
class SyncWidthColumn extends StatefulWidget {
  final List<Row> children;

  const SyncWidthColumn({Key? key, required this.children}) : super(key: key);

  @override
  _SyncWidthColumnState createState() => _SyncWidthColumnState();
}

class _SyncWidthColumnState extends State<SyncWidthColumn> {
  late List<double?> maxColumnWidths;
  late List<List<GlobalKey>> rowKeys;
  bool inMeasurementPass = true;

  @override
  void initState() {
    super.initState();

    int maxColumns = widget.children.fold<int>(
      0,
      (prev, row) => row.children.length > prev ? row.children.length : prev,
    );

    maxColumnWidths = List.filled(maxColumns, null);
    rowKeys = List.generate(widget.children.length,
        (_) => List.generate(maxColumns, (_) => GlobalKey()));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (int rowIndex = 0; rowIndex < widget.children.length; rowIndex++) {
        for (int colIndex = 0;
            colIndex < widget.children[rowIndex].children.length;
            colIndex++) {
          measureWidth(rowKeys[rowIndex][colIndex], colIndex);
        }
      }
      if (mounted) {
        setState(() {
          inMeasurementPass = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.children.length,
      itemBuilder: (context, rowIndex) {
        return _SyncWidthRow(
          children: widget.children[rowIndex].children,
          maxColumnWidths: maxColumnWidths,
          rowKeys: rowKeys[rowIndex],
          inMeasurementPass: inMeasurementPass,
        );
      },
    );
  }

  void measureWidth(GlobalKey key, int colIndex) {
    final RenderBox? renderBox =
        key.currentContext?.findRenderObject() as RenderBox?;
    final size = renderBox?.size;

    if (size != null &&
        (maxColumnWidths[colIndex] == null ||
            size.width > maxColumnWidths[colIndex]!)) {
      setState(() {
        maxColumnWidths[colIndex] = size.width;
      });
    }
  }
}

class _SyncWidthRow extends StatelessWidget {
  final List<Widget> children;
  final List<double?> maxColumnWidths;
  final List<GlobalKey> rowKeys;
  final bool inMeasurementPass;

  _SyncWidthRow({
    required this.children,
    required this.maxColumnWidths,
    required this.rowKeys,
    required this.inMeasurementPass,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(maxColumnWidths.length, (colIndex) {
        if (colIndex < children.length) {
          Widget child = children[colIndex];
          GlobalKey key = rowKeys[colIndex];

          if (inMeasurementPass) {
            return Container(
              key: key,
              child: child,
            );
          } else {
            return SizedBox(
              width: maxColumnWidths[colIndex],
              child: child,
            );
          }
        }
        return const SizedBox.shrink(); // for non-existing children
      }),
    );
  }
}
