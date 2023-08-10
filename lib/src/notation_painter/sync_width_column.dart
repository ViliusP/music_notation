import 'package:flutter/widgets.dart';

/// `SyncWidthColumn` is a widget that synchronizes the width of children
/// inside rows based on the maximum width child for each corresponding position
/// across all rows. This is useful for creating grids or tables where each
/// "column" should be aligned in width, but the children themselves have varying widths.
///
/// Principles of Implementation:
///
/// 1. **Initialization**: A set of GlobalKeys is created for each widget in every row.
///
/// 2. **Measurement Phase (First Pass)**: Initially, children in each row are rendered without
/// any width constraints. Those children that exist in a specific column
/// are assigned a GlobalKey from the previously created set. This allows
/// us to obtain their width post-rendering.
///
/// 3. **Aggregate Width Measurements**: After the Measurement Phase, the maximum width
/// for each "column" is determined based on the rendered widths of the children.
///
/// 4. **Layout Phase (Second Pass)**: Using `ListView.builder`, the widget lazily builds rows
/// while applying the calculated maximum widths as fixed widths to each corresponding child
/// in all rows. This ensures that each "column" of children has a uniform width across all rows.
///
/// Example:
///
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
/// In the example above, the width of the first child in each row (the "first column")
/// will be determined by 'This is a much longer text' as it has the maximum width.
/// Similarly, the widths of the second and third children ("columns") will be synchronized
/// based on their maximum width counterparts.
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
  }

  @override
  Widget build(BuildContext context) {
    if (inMeasurementPass) {
      // Trigger the layout pass after the initial render
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          if (!mounted) return;
          setState(() {
            inMeasurementPass = false;
          });
        },
      );
    }

    return ListView.builder(
      itemCount: widget.children.length,
      itemBuilder: (context, rowIndex) {
        Row row = widget.children[rowIndex];
        return Row(
          children: List.generate(maxColumnWidths.length, (colIndex) {
            if (colIndex < row.children.length) {
              Widget child = row.children[colIndex];
              GlobalKey key = rowKeys[rowIndex][colIndex];

              // If it's the measurement pass, don't set a width
              if (inMeasurementPass) {
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) => measureWidth(key, colIndex),
                );
                return Container(
                  key: key,
                  child: child,
                );
              } else {
                // If it's the layout pass, set the width
                return SizedBox(
                  width: maxColumnWidths[colIndex],
                  child: child,
                );
              }
            }
            return const SizedBox.shrink(); // for non-existing children
          }),
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
      maxColumnWidths[colIndex] = size.width;
    }
  }
}
