/// Enum to specify how the barline should extend when rendering
enum BarlineExtension {
  none, // No extension: Barline is rendered only on the current staff
  top, // Extend upwards: Connects the barline to the staff above
  bottom, // Extend downwards: Connects the barline to the staff below
  both // Extend both upwards and downwards to connect with other staves
}

// Enum to specify where barlines is located in measure.
enum BarlineLocation {
  start,
  end;
}

// Class to configure barline extensions for rendering start and end barlines in a measure
class MeasureBarlines {
  // Defines the extension behavior for the start of the barline
  final BarlineExtension? start;
  // Defines the extension behavior for the end of the barline
  final BarlineExtension? end;

  // Constructor with default values set to 'none' for both start and end extensions
  const MeasureBarlines({
    this.start = BarlineExtension.none,
    this.end = BarlineExtension.none,
  });

  factory MeasureBarlines.fromGridData({
    required int gridX,
    required int gridY,
    required int maxX,
    required int maxY,
    required int staff,
    required int staffCount,
  }) {
    BarlineExtension startExtension = BarlineExtension.none;
    BarlineExtension endExtension = BarlineExtension.none;

    if (gridX == 0 && maxY > 1) {
      if (gridY == 0) {
        startExtension = BarlineExtension.bottom;
      }
      if (gridY > 0 && gridY < maxY - 1) {
        startExtension = BarlineExtension.both;
      }
      if (gridY == maxY - 1) {
        startExtension = BarlineExtension.top;
      }
    }

    if (staffCount > 1) {
      if (staff == 1) endExtension = BarlineExtension.bottom;
      if (staff > 1 && staff < staffCount) endExtension = BarlineExtension.both;
      if (staff == staffCount) endExtension = BarlineExtension.top;
    }

    return MeasureBarlines(
      start: startExtension,
      end: endExtension,
    );
  }

  MeasureBarlines copyWith({BarlineExtension? start, BarlineExtension? end}) {
    return MeasureBarlines(
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }
}
