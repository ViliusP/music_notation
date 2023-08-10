import 'package:flutter/widgets.dart';

/// `SyncWidthColumn` is a widget that synchronizes the width of children
/// inside rows based on the maximum width child for each corresponding position
/// across all rows. This is useful for creating grids or tables where each
/// "column" should be aligned in width, but the children themselves have varying widths.
///
/// Principles of Implementation:
///
/// 1. **Measurement Phase**: Initially, we render the children without any width constraints.
///    Each child gets a GlobalKey, which allows us to obtain its width post-rendering.
///
/// 2. **Width Synchronization**: After gathering all the widths from the first render,
///    we calculate the maximum width for each "column" and store them in a list.
///
/// 3. **Re-render with Constraints**: The widget then rebuilds, applying the calculated maximum
///    widths as fixed widths to each corresponding child in all rows. This ensures that each
///    "column" of children has a uniform width across all rows.
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

  const SyncWidthColumn({super.key, required this.children});

  @override
  State createState() => _SyncWidthColumnState();
}

class _SyncWidthColumnState extends State<SyncWidthColumn> {
  // Store measured widths for each row's children
  late List<List<double>> rowsWidths;

  // Store maximum widths for each column
  List<double> maxColumnWidths = [];

  bool measured = false;

  @override
  void initState() {
    super.initState();

    // Initialize rowsWidths based on the provided children
    rowsWidths = List.generate(widget.children.length,
        (index) => List.filled(widget.children[index].children.length, 0.0));
  }

  @override
  Widget build(BuildContext context) {
    if (!measured) {
      return Column(
        children: widget.children.map((row) {
          int rowIndex = widget.children.indexOf(row);
          return Row(
            children: row.children.map((child) {
              int colIndex = row.children.indexOf(child);
              GlobalKey key = GlobalKey();

              // Schedule width measurement for after the frame
              WidgetsBinding.instance!.addPostFrameCallback(
                  (_) => measureWidth(key, rowIndex, colIndex));

              return Container(key: key, child: child);
            }).toList(),
          );
        }).toList(),
      );
    } else {
      return Column(
        children: widget.children.map((row) {
          return Row(
            children: row.children.map((child) {
              int colIndex = row.children.indexOf(child);
              return SizedBox(width: maxColumnWidths[colIndex], child: child);
            }).toList(),
          );
        }).toList(),
      );
    }
  }

  // Measure width of a widget after it's rendered
  measureWidth(GlobalKey key, int rowIndex, int colIndex) {
    final RenderBox? renderBox =
        key.currentContext?.findRenderObject() as RenderBox?;
    final size = renderBox?.size;

    if (size != null) {
      setState(() {
        rowsWidths[rowIndex][colIndex] = size.width;

        // Check if all widths are measured
        if (rowsWidths.every((row) => row.every((width) => width > 0))) {
          measured = true;

          // Calculate max width for each column
          for (var i = 0; i < widget.children[0].children.length; i++) {
            var maxColumnWidth = 0.0;
            for (var row in rowsWidths) {
              if (row[i] > maxColumnWidth) {
                maxColumnWidth = row[i];
              }
            }
            maxColumnWidths.add(maxColumnWidth);
          }
        }
      });
    }
  }
}
