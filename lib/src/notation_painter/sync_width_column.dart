import 'package:flutter/widgets.dart';

/// `SyncWidthColumn` is a widget that synchronizes the width of children
/// inside rows based on the maximum width child for each corresponding position
/// across all rows. This is useful for creating grids or tables where each
/// "column" should be aligned in width, but the children themselves have varying widths.
///
/// Principles of Implementation:
///
/// 1. **Measurement Phase**: Initially, children in each row are rendered without
/// any width constraints. Only those children that exist in a specific column
/// are assigned a GlobalKey. This allows us to obtain their width post-rendering.
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
  List<double?> maxColumnWidths = [];

  @override
  void initState() {
    super.initState();
    int maxColumns = widget.children.fold(
      0,
      (prev, row) => row.children.length > prev ? row.children.length : prev,
    );
    maxColumnWidths = List.filled(maxColumns, null);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.children.map((row) {
        return Row(
          children: List.generate(maxColumnWidths.length, (colIndex) {
            if (colIndex < row.children.length) {
              Widget child = row.children[colIndex];
              GlobalKey key = GlobalKey();

              // Schedule width measurement for after the frame
              WidgetsBinding.instance.addPostFrameCallback(
                (_) => measureWidth(key, colIndex),
              );

              return SizedBox(
                key: key,
                width: maxColumnWidths[colIndex],
                child: child,
              );
            }
            // Return a non-visible widget for non-existing children
            return const SizedBox.shrink();
          }),
        );
      }).toList(),
    );
  }

  measureWidth(GlobalKey key, int colIndex) {
    final RenderBox? renderBox =
        key.currentContext?.findRenderObject() as RenderBox?;
    final size = renderBox?.size;

    if (size != null) {
      setState(() {
        if (maxColumnWidths[colIndex] == null ||
            size.width > maxColumnWidths[colIndex]!) {
          maxColumnWidths[colIndex] = size.width;
        }
      });
    }
  }
}
