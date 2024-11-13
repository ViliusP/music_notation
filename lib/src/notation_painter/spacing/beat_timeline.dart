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
  static const double _spaceBetweenQuarters =
      NotationLayoutProperties.staveHeight * 1.5;

  double get spacePerBeat => _spaceBetweenQuarters / divisions;

  const BeatTimeline({
    required this.values,
    required this.divisions,
  });

  /// Creates a [BeatTimeline] from a [Timeline] and filters by a specified voice.
  ///
  /// Iterates through each value in the [timeline] and includes elements matching the specified [voice].
  /// Adjusts offsets for accurate beat placements.
  factory BeatTimeline.fromTimeline(Timeline timeline) {
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
    required Timeline timeline,
    required String voice,
  }) {
    int? parsedVoice = int.tryParse(voice);
    List<BeatTimelineValue> values = [];

    double lastAttributeOffset = NotationLayoutProperties.staveSpace;
    for (var entry in timeline._values.entries) {
      List<_TimelineValue> beatCol = entry.value.sorted(
        (a, b) => a.voice.compareTo(b.voice),
      );
      for (_TimelineValue value in beatCol) {
        int? valueVoice = int.tryParse(value.voice);
        // Skip if the voice does not match and it's not an unassigned voice.
        if (parsedVoice == null ||
            parsedVoice < 0 ||
            (parsedVoice != valueVoice && (valueVoice ?? 0) > 0)) {
          continue;
        }
        if (value.duration == 0) {
          lastAttributeOffset += value.width;
          lastAttributeOffset += NotationLayoutProperties.staveSpace;
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

    /// Remove last if it is cursor to back
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

  /// Converts the timeline into a list of spatial values based on time units for rendering.
  ///
  /// This method processes the internal timeline data to produce a list of `double` values
  /// that represent the spatial distribution of musical elements (e.g., notes, rests) within the timeline.
  /// Each value corresponds to the position of an element on the timeline, calculated based on the provided
  /// spacing configuration for each division of time.
  ///
  /// ### Parameters:
  /// - [children] - A list of [MeasureWidget] elements representing musical components within the measure.
  ///
  /// ### Returns:
  /// A list of spatial values as `double` values, corresponding to the positions of elements on the timeline.
  /// The returned list has a size of `[children.length] + 1`, where each index aligns with a child in the [children] list.
  /// An additional index at the end represents the cumulative width (or end) of the measure.
  ///
  /// ### Example:
  /// ```dart
  /// Timeline timeline = Timeline(divisions: 4.0);
  /// // Populate the timeline with beats and elements
  /// List<double> spacings = timeline.toSpacings(measureWidgets);
  /// // spacings now contains spatial positions for each MeasureWidget based on timeline divisions
  /// ```
  List<double> toSpacings(List<MeasureWidget> children) {
    var tValues = Timeline.fromMeasureElements(children)._values;
    List<double> spacings = List.generate(children.length, (_) => 0);
    List<double> beatSpacing = toDivisionsSpacing();

    double lastAttributeOffset = 0;
    for (var entry in tValues.entries) {
      List<_TimelineValue> beatCol = entry.value.sorted(
        (a, b) => a.voice.compareTo(b.voice),
      );

      int beat = entry.key.value;

      double attributeOffset = lastAttributeOffset;
      for (_TimelineValue value in beatCol) {
        if (value.duration != 0) {
          int beatIndex = beat.clamp(0, beatSpacing.length - 1);
          spacings[value.index] = beatSpacing[beatIndex];
        }

        if (value.duration == 0) {
          attributeOffset += NotationLayoutProperties.staveSpace;
          spacings[value.index] = attributeOffset;
          attributeOffset += value.width;
        }
      }
      if (values.elementAtOrNull(beat)?.lastAttributeOffset != null) {
        lastAttributeOffset = values[beat]!.lastAttributeOffset;
      }
    }

    // Calculate final spacing to mark measure width based on last beat offset.
    double lastSpacing = beatSpacing.last;
    // Increase width if last beat has a note
    lastSpacing += (values.last?.width ?? 0);
    // Padding to avoid barline overlap
    lastSpacing += NotationLayoutProperties.staveSpace;
    spacings.add(lastSpacing);
    return spacings;
  }

  /// Computes the spacing between each division of the timeline for accurate positioning of elements.
  ///
  /// This method calculates the spatial offsets for each beat division based on the value of
  /// [_spaceBetweenQuarters] and the [divisions] in the measure, creating a list of
  /// cumulative spacings for element alignment.
  ///
  /// ### Returns:
  /// A list of `double` values, each representing the cumulative spacing at each beat division.
  List<double> toDivisionsSpacing() {
    List<double> spacings = [];
    final double spacePerBeat = _spaceBetweenQuarters / divisions;
    double lastAttributeOffset = 0;
    for (var (i, value) in values.indexed) {
      double spacingFromLeft = 0;

      if (lastAttributeOffset != value?.lastAttributeOffset && value != null) {
        spacingFromLeft += (value.lastAttributeOffset - lastAttributeOffset);
      }
      if (i != 0) {
        spacingFromLeft += spacePerBeat;
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
