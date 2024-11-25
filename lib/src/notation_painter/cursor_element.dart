import 'package:flutter/widgets.dart';
import 'package:music_notation/src/notation_painter/measure/measure_element.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/properties/layout_properties.dart';
import 'package:music_notation/src/notation_painter/utilities/size_extensions.dart';

/// Represents the `<forward>` and `<backup>` element in MusicXML, which moves the cursor
/// backward or forward in time by a specified duration without rendering any visual element.
/// This helps in managing the timing for subsequent elements, especially in multiple voices.
class CursorElement extends StatelessWidget implements MeasureWidget {
  /// Duration to move foward or backup. The negative values represents `<backup>`
  /// duration and the positives represents `<forward>` duration.
  final double duration;

  final String? voice;

  final int? staff;

  @override
  AlignmentPosition get alignmentPosition => AlignmentPosition(
        left: 0,
        top: -size.height / 2,
      );

  @override
  AlignmentPositionV2 get alignmentPositionV2 => AlignmentPositionV2(
        left: 0,
        top: 0,
      );

  /// Generic position as `<forward>` does not correspond to a specific musical position.
  @override
  ElementPosition get position => ElementPosition.staffMiddle;

  /// `<forward>` does not occupy any visual space.
  @override
  Size get size => baseSize.scale(NotationLayoutProperties.defaultStaveSpace);

  @override
  Size get baseSize => const Size(0.25, 0.25);

  /// Creates a [CursorElement] with the given [duration] data.
  const CursorElement({
    super.key,
    required this.duration,
    this.voice,
    this.staff,
  });

  /// Since `<forward>` is a structural element, it does not render anything visually.
  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink();

    // Optional: Uncomment the below code for debugging purposes.
    /*
    return Container(
      width: 10,
      height: 10,
      color: Colors.blue.withOpacity(0.3),
      child: Center(
        child: Text(
          'F',
          style: TextStyle(fontSize: 8, color: Colors.white),
        ),
      ),
    );
    */
  }
}
