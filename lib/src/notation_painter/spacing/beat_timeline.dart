part of 'timeline.dart';

/// Represents the timeline for rhythmic elements (notes, rests, chords) within a measure for a single voice.
class BeatTimeline {
  /// Divisions per beat in the timeline, used to determine placement accuracy.
  final double divisions;

  /// Stores the beat values for each position in the timeline.
  /// Each element represents a beat position and may be `null` to indicate empty or unoccupied slots.
  final List<BeatTimelineValue?> values;

  /// Calculates the total duration covered by this timeline, summing all durations of non-null beats.
  double get duration => values.fold(
        0,
        (double duration, element) => duration + (element?.duration ?? 0),
      );

  /// Space between two quarter notes measured from their alignment axes.
  static const double _baseSpaceBetweenQuarters = 6;

  double get spacePerDivision => _baseSpaceBetweenQuarters / divisions;

  const BeatTimeline({
    required this.values,
    required this.divisions,
  });

  /// Creates a [BeatTimeline] from a [Timeline] and filters by a specified voice.
  ///
  /// Iterates through each value in the [timeline] and includes elements matching the specified [voice].
  /// Adjusts offsets for accurate beat placements.
  factory BeatTimeline.fromTimeline(MeasureTimeline timeline) {
    BeatTimeline? finalBeatline;

    for (var voice in timeline.uniqueVoices) {
      if ((int.tryParse(voice) ?? 0) > 0) {
        BeatTimeline beatTimeline = BeatTimeline._fromVoiceTimeline(
          timeline: timeline,
          voice: voice,
        );
        finalBeatline ??= beatTimeline;
        finalBeatline = beatTimeline.combine(finalBeatline);
      }
    }
    return finalBeatline!;
  }

  /// Creates a [BeatTimeline] from a [Timeline] and filters by a specified voice.
  ///
  /// Iterates through each value in the [timeline] and includes elements matching the specified [voice].
  /// Adjusts offsets for accurate beat placements.
  factory BeatTimeline._fromVoiceTimeline({
    required MeasureTimeline timeline,
    required String voice,
  }) {
    int? parsedVoice = int.tryParse(voice);
    List<BeatTimelineValue> values = [];

    double lastAttributeOffset = 1;
    for (var entry in timeline.values.entries) {
      List<TimelineValue> beatCol = entry.value.sorted(
        (a, b) => a.voice.compareTo(b.voice),
      );
      for (TimelineValue value in beatCol) {
        int? valueVoice = int.tryParse(value.voice);
        // Skip if the voice does not match and it's not an unassigned voice.
        if (parsedVoice == null ||
            parsedVoice < 0 ||
            (parsedVoice != valueVoice && (valueVoice ?? 0) > 0)) {
          continue;
        }
        if (value.duration == 0) {
          lastAttributeOffset += value.width;
          lastAttributeOffset += 1;
        }
        if (value.duration != 0) {
          values.add(BeatTimelineValue(
            duration: value.duration,
            width: value.width,
            leftOffset: value.leftOffset,
            lastAttributeOffset: lastAttributeOffset == 0
                ? values.last.lastAttributeOffset
                : lastAttributeOffset,
          ));
        }
      }
    }

    // Remove last if it is backup cursor
    if (values.last.duration < 0) {
      values.removeLast();
    }
    while (values.first.duration < 0) {
      values.removeAt(0);
    }
    return BeatTimeline(
      values: values,
      divisions: timeline.divisions,
    ).normalize();
  }

  /// Combines this timeline with another [BeatTimeline] and returns a new timeline with adjusted values.
  ///
  /// Requires that both timelines have compatible `duration` and `divisions`.
  BeatTimeline combine(BeatTimeline other) {
    if (duration / divisions != other.duration / other.divisions) {
      throw ArgumentError(
        "Duration and divisions ratio of provided BeatTimeline is different",
        "other.duration",
      );
    }

    final List<BeatTimelineValue?> combined = [];

    BeatTimeline bl1 = normalize();
    BeatTimeline bl2 = other.normalize();
    // Ensure both timelines share the same number of divisions.
    if (bl1.divisions < bl2.divisions) {
      bl1 = bl1.changeDivisions(bl2.divisions);
    }
    if (bl2.divisions < bl1.divisions) {
      bl2 = bl2.changeDivisions(bl1.divisions);
    }

    BeatTimelineValue? lastAdded;

    for (int i = 0; i < bl1.values.length; i++) {
      BeatTimelineValue? bl1Value = bl1.values.elementAtOrNull(i);
      BeatTimelineValue? bl2Value = bl2.values.elementAtOrNull(i);

      if (bl1Value == null && bl2Value == null) {
        combined.add(null);
      }
      if (bl1Value != null && bl2Value == null) {
        combined.add(
          bl1Value.copyWith(
            lastAttributeOffset:
                lastAdded?.lastAttributeOffset ?? bl1Value.lastAttributeOffset,
          ),
        );
        lastAdded = combined.last;
      }
      if (bl1Value == null && bl2Value != null) {
        combined.add(
          bl2Value.copyWith(
            lastAttributeOffset:
                lastAdded?.lastAttributeOffset ?? bl2Value.lastAttributeOffset,
          ),
        );
        lastAdded = combined.last;
      }
      if (bl1Value != null && bl2Value != null) {
        combined.add(BeatTimelineValue(
          duration: [bl1Value.duration, bl2Value.duration].min,
          width: [bl1Value.width, bl2Value.width].max,
          leftOffset: [bl1Value.leftOffset, bl2Value.leftOffset].max,
          lastAttributeOffset: [
            bl1Value.lastAttributeOffset,
            bl2Value.lastAttributeOffset,
          ].max,
        ));
        lastAdded = combined.last;
      }
    }

    return BeatTimeline(values: combined, divisions: bl1.divisions);
  }

  /// Changes the divisions of this timeline to the specified [value] and returns a new [BeatTimeline].
  ///
  /// The new divisions value must be greater than the current one.
  BeatTimeline changeDivisions(double value) {
    if (value < divisions) {
      throw ArgumentError(
        "The new value of divisions must be bigger than the old value",
        "value",
      );
    }
    if (value == divisions) return this;
    double ratio = value / divisions;

    final List<BeatTimelineValue?> modified = List.generate(
      (duration * ratio).toInt(),
      (i) => null,
    );
    int i = 0;
    for (final value in values) {
      if (value != null) {
        modified[i] = value.copyWith(
          duration: value.duration * ratio.toInt(),
        );
        i += (value.duration * ratio).toInt();
      }
    }

    return BeatTimeline(values: modified, divisions: value);
  }

  /// Normalizes the timeline, ensuring each duration unit has a corresponding position, including `null` slots for rests.
  BeatTimeline normalize() {
    final List<BeatTimelineValue?> normalized = [];
    int i = 0;
    for (final value in values) {
      if (value != null) {
        normalized.add(value);
        i++;
      }

      // Add `null` slots for gaps between beat positions.
      for (int j = 1; j < (value?.duration ?? 0); j++, i++) {
        normalized.add(null);
      }
    }
    return BeatTimeline(values: normalized, divisions: divisions);
  }

  /// Converts the beat timeline into a list of offsets from the measure start for rendering.
  ///
  /// This method generates a list of `double` values representing the offset positions of musical elements
  /// (e.g., notes, rests) within the measure. Each value in the list corresponds to the horizontal position
  /// of an element on the timeline, calculated based on each division’s spatial allocation for consistent
  /// element spacing.
  ///
  /// ### Parameters:
  /// - [children] - A list of [MeasureWidget] elements representing musical components within the measure.
  ///
  /// ### Returns:
  /// A list of offset values as `double`, where each index corresponds to the position of a `MeasureWidget`
  /// in the [children] list. The list includes an additional final entry representing the cumulative width
  /// (or end position) of the measure.
  ///
  /// ### Example:
  /// ```dart
  /// Timeline timeline = Timeline(divisions: 4.0);
  /// // Populate the timeline with beats and elements
  /// List<double> spacings = timeline.toSpacings(measureWidgets);
  /// // spacings now contains horizontal positions for each MeasureWidget in the measure
  /// ```
  List<double> toSpacings(List<MeasureWidget> children) {
    var tValues = MeasureTimeline.fromMeasureElements(children).values;
    List<double> spacings = List.generate(children.length, (_) => 0);
    List<double> beatSpacing = toDivisionsSpacing();
    int? measureRestIndex;
    double lastAttributeOffset = 0;
    for (var entry in tValues.entries) {
      List<TimelineValue> beatCol = entry.value.sorted(
        (a, b) => a.voice.compareTo(b.voice),
      );

      int beat = entry.key.value;

      double attributeOffset = lastAttributeOffset;
      for (TimelineValue value in beatCol) {
        if (value.duration != 0) {
          // Check if the element is a measure rest and store its index
          if (children[value.index].tryAs<RestElement>()?.isMeasure == true) {
            measureRestIndex = value.index;
            break;
          }
          int beatIndex = beat.clamp(0, beatSpacing.length - 1);
          spacings[value.index] = beatSpacing[beatIndex];
        }

        if (value.duration == 0) {
          attributeOffset += 1;
          spacings[value.index] = attributeOffset;
          attributeOffset += value.width;
        }
      }
      if (values.elementAtOrNull(beat)?.lastAttributeOffset != null) {
        lastAttributeOffset = values[beat]!.lastAttributeOffset;
      }
      // Stop further processing if a measure rest has been found
      if (measureRestIndex != null) {
        break;
      }
    }

    // Calculate final spacing to mark measure width based on last beat offset.
    // and increase width for whole division.
    spacings.add(beatSpacing.last + spacePerDivision);

    if (measureRestIndex != null) {
      // Start the rest positioning from the first beat offset.
      double restPosition = beatSpacing[0];
      // Adjust rest to start after any initial attribute spacing.
      restPosition -= 1;
      // Move the rest to the center of the measure, between attribute end and barline or between two barlines.
      restPosition += (beatSpacing.last - restPosition) / 2;
      // Center-align the rest by adjusting for half of its width.
      restPosition -= children[measureRestIndex].baseSize.width / 2;
      spacings[measureRestIndex] = restPosition;
    }
    return spacings;
  }

  /// Computes the cumulative spacing for each division in the timeline, defining element positioning.
  ///
  /// This method calculates spatial offsets across the timeline’s beat divisions based on the
  /// defined [_spaceBetweenQuarters] and [divisions], resulting in a list of cumulative spacing
  /// values to guide element alignment.
  ///
  /// ### Returns:
  /// A list of `double` values, where each value represents the cumulative offset at each beat division.
  List<double> toDivisionsSpacing() {
    List<double> spacings = [];
    double lastAttributeOffset = 0;
    for (var (i, value) in values.indexed) {
      double spacingFromLeft = 0;

      if (lastAttributeOffset != value?.lastAttributeOffset && value != null) {
        spacingFromLeft += (value.lastAttributeOffset - lastAttributeOffset);
      }
      if (i != 0) {
        spacingFromLeft += spacePerDivision;
      }
      spacingFromLeft += spacings.lastOrNull ?? 0;

      spacings.add(spacingFromLeft);
      if (value != null) {
        lastAttributeOffset = value.lastAttributeOffset;
      }
    }
    return spacings;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BeatTimeline &&
          runtimeType == other.runtimeType &&
          divisions == other.divisions &&
          listEquals(values, other.values);

  @override
  int get hashCode => Object.hash(divisions, Object.hashAll(values));

  @override
  String toString() {
    if (kDebugMode) {
      List<List<String>> table = [
        [
          'Beat',
          '----------------',
          'Duration',
          'Width',
          'Left Offset',
          'Offset from Last'
        ]
      ];

      for (var (i, val) in values.indexed) {
        List<String> col = [];

        String width = val?.width.toString() ?? " > ";
        if (val?.width == 0) {
          width = ">F>";
        }

        col.addAll([
          i.toString(),
          '----',
          val?.duration.toString() ?? " > ",
          width,
          val?.leftOffset.toString() ?? " > ",
          val?.lastAttributeOffset.toString() ?? " > "
        ]);
        table.add(col.toList());
      }
      List<List<String>> formattedTable = table.map((col) {
        int colSize = col.map((v) => v.length).max;

        return col.map((v) => v.padRight(colSize)).toList();
      }).toList();

      List<String> stringTable = [];
      for (var colIndex in List.generate(table.first.length, (i) => i)) {
        String row = "| ";
        for (var col in formattedTable) {
          row += col[colIndex];
          row += " | ";
        }
        stringTable.add(row);
      }

      String generalInfo =
          "|${"-" * 18}|\n| Divisions: $divisions\n|${"-" * 18}|";

      return "\n$generalInfo\n${stringTable.join("\n")}";
    }
    return super.toString();
  }
}

/// Represents a single beat position in the timeline, including width, offset, and duration details.
class BeatTimelineValue {
  final double width;
  final double leftOffset;
  final double duration;
  final double lastAttributeOffset;

  const BeatTimelineValue({
    required this.width,
    required this.leftOffset,
    required this.duration,
    required this.lastAttributeOffset,
  });

  /// Creates a copy of this BeatTimelineValue with optional new values for
  /// each field.
  BeatTimelineValue copyWith({
    double? width,
    double? leftOffset,
    double? duration,
    double? lastAttributeOffset,
  }) {
    return BeatTimelineValue(
      width: width ?? this.width,
      leftOffset: leftOffset ?? this.leftOffset,
      duration: duration ?? this.duration,
      lastAttributeOffset: lastAttributeOffset ?? this.lastAttributeOffset,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BeatTimelineValue &&
          runtimeType == other.runtimeType &&
          width == other.width &&
          leftOffset == other.leftOffset &&
          duration == other.duration &&
          lastAttributeOffset == other.lastAttributeOffset;

  @override
  int get hashCode =>
      Object.hash(width, leftOffset, duration, lastAttributeOffset);
}
