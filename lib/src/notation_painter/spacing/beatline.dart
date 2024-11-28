part of 'timeline.dart';

/// Represents the timeline for rhythmic elements (notes, rests, chords) within a measure for a single voice.
class Beatline {
  /// Divisions per beat in the timeline, used to determine placement accuracy.
  final double divisions;

  /// Stores the beat values for each position in the timeline.
  /// Each element represents a beat position and may be `null` to indicate empty or unoccupied slots.
  final List<BeatlineValue?> values;

  final bool normalized;

  /// Calculates the total duration covered by this timeline, summing all durations of non-null beats.
  final double duration;

  /// Space between two quarter notes measured from their alignment axes.
  // static const double _spaceBetweenQuarters = 1.5;

  // double get spacePerDivision => _spaceBetweenQuarters / divisions;

  const Beatline({
    required this.values,
    required this.divisions,
    required this.duration,
    this.normalized = false,
  });

  /// Creates a [BeatTimeline] from a [Timeline] and filters by a specified voice.
  ///
  /// Iterates through each value in the [timeline] and includes elements matching the specified [voice].
  /// Adjusts offsets for accurate beat placements.
  factory Beatline.fromTimeline(MeasureTimeline timeline) {
    Beatline? finalBeatline;

    for (var voice in timeline.uniqueVoices) {
      if ((int.tryParse(voice) ?? 0) > 0) {
        Beatline beatTimeline = Beatline._fromVoiceTimeline(
          timeline: timeline,
          voice: voice,
        );
        finalBeatline ??= beatTimeline;
        finalBeatline = beatTimeline.combine(finalBeatline);
      }
    }
    return finalBeatline!;
  }

  /// Creates a [Beatline] from a [MeasureTimeline] and filters by a specified voice.
  ///
  /// Iterates through each value in the [timeline] and includes elements matching the specified [voice].
  /// Adjusts offsets for accurate beat placements.
  factory Beatline._fromVoiceTimeline({
    required MeasureTimeline timeline,
    required String voice,
  }) {
    int? parsedVoice = int.tryParse(voice);
    List<BeatlineValue> values = [];

    int attributes = 0;
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
          attributes++;
        }
        if (value.duration != 0) {
          values.add(BeatlineValue(
            duration: value.duration,
            attributesBefore: attributes,
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

    var lastRhytmhic = timeline.values.entries.lastWhere(
      (e) => e.key.isRhytmic,
    );

    double lastDuration = lastRhytmhic.value.map((v) => v.duration).max;

    int duration = lastDuration.toInt();
    if (duration < 0) duration = 0;

    duration += lastRhytmhic.key.index;
    return Beatline(
      values: values,
      divisions: timeline.divisions,
      normalized: true,
      duration: duration.toDouble(),
    ).normalize();
  }

  /// Combines this timeline with another [BeatTimeline] and returns a new timeline with adjusted values.
  ///
  /// Requires that both timelines have compatible `duration` and `divisions`.
  Beatline combine(Beatline other) {
    if (duration / divisions != other.duration / other.divisions) {
      throw ArgumentError(
        "Duration and divisions ratio of provided BeatTimeline is different:\nduration: $duration, other.duration: ${other.duration} \ndivisions: $divisions, other.divisions ${other.divisions}",
        "other.duration",
      );
    }

    final List<BeatlineValue?> combined = [];

    Beatline bl1 = normalize();
    Beatline bl2 = other.normalize();

    // print("-------------------------");
    // print("Before: $duration After ${bl1.duration} bl1");
    // print("Before: ${other.duration} After ${bl2.duration} bl2");

    // Ensure both timelines share the same number of divisions.
    if (bl1.divisions < bl2.divisions) {
      bl1 = bl1.changeDivisions(bl2.divisions);
    }
    if (bl2.divisions < bl1.divisions) {
      bl2 = bl2.changeDivisions(bl1.divisions);
    }

    // print("-----Divisions-------");
    // print("Before: $divisions After ${bl1.divisions} bl1");
    // print("Before: ${other.divisions} After ${bl2.divisions} bl2");

    BeatlineValue? lastAdded;

    for (int i = 0; i < bl1.values.length; i++) {
      BeatlineValue? bl1Value = bl1.values.elementAtOrNull(i);
      BeatlineValue? bl2Value = bl2.values.elementAtOrNull(i);

      if (bl1Value == null && bl2Value == null) {
        combined.add(null);
      }
      if (bl1Value != null && bl2Value == null) {
        combined.add(
          bl1Value.copyWith(
            attributesBefore:
                lastAdded?.attributesBefore ?? bl1Value.attributesBefore,
          ),
        );
        lastAdded = combined.last;
      }
      if (bl1Value == null && bl2Value != null) {
        combined.add(
          bl2Value.copyWith(
            attributesBefore:
                lastAdded?.attributesBefore ?? bl2Value.attributesBefore,
          ),
        );
        lastAdded = combined.last;
      }
      if (bl1Value != null && bl2Value != null) {
        combined.add(BeatlineValue(
          duration: [bl1Value.duration, bl2Value.duration].min,
          attributesBefore: [
            bl1Value.attributesBefore,
            bl2Value.attributesBefore,
          ].max,
        ));
        lastAdded = combined.last;
      }
    }
    // print("After everything: ${bl1.duration}");
    return Beatline(
      values: combined,
      divisions: bl1.divisions,
      normalized: true,
      duration: bl1.duration,
    );
  }

  /// Changes the divisions of this timeline to the specified [value] and returns a new [BeatTimeline].
  ///
  /// The new divisions value must be greater than the current one.
  Beatline changeDivisions(double value) {
    if (value < divisions) {
      throw ArgumentError(
        "The new value of divisions must be bigger than the old value",
        "value",
      );
    }
    if (value == divisions) return this;
    double ratio = value / divisions;

    final List<BeatlineValue?> modified = List.generate(
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

    return Beatline(
      values: modified,
      divisions: value,
      normalized: true,
      duration: duration * ratio,
    );
  }

  /// Normalizes the timeline, ensuring each duration unit has a corresponding position, including `null` slots for rests.
  Beatline normalize() {
    final List<BeatlineValue?> normalized = List.generate(
      duration.toInt(),
      (_) => null,
    );

    for (int i = 0; i < normalized.length; i++) {
      if (values.elementAtOrNull(i) != null) {
        normalized[i] = values[i];
      }
    }

    return Beatline(
      values: normalized,
      divisions: divisions,
      normalized: true,
      duration: duration,
    );
  }

  // /// Converts the beat timeline into a list of offsets from the measure start for rendering.
  // ///
  // /// This method generates a list of `double` values representing the offset positions of musical elements
  // /// (e.g., notes, rests) within the measure. Each value in the list corresponds to the horizontal position
  // /// of an element on the timeline, calculated based on each division’s spatial allocation for consistent
  // /// element spacing.
  // ///
  // /// ### Parameters:
  // /// - [children] - A list of [MeasureWidget] elements representing musical components within the measure.
  // ///
  // /// ### Returns:
  // /// A list of offset values as `double`, where each index corresponds to the position of a `MeasureWidget`
  // /// in the [children] list. The list includes an additional final entry representing the cumulative width
  // /// (or end position) of the measure.
  // ///
  // /// ### Example:
  // /// ```dart
  // /// Timeline timeline = Timeline(divisions: 4.0);
  // /// // Populate the timeline with beats and elements
  // /// List<double> spacings = timeline.toSpacings(measureWidgets);
  // /// // spacings now contains horizontal positions for each MeasureWidget in the measure
  // /// ```
  // List<double> toSpacings(List<MeasureWidget> children) {
  //   var tValues = MeasureTimeline.fromMeasureElements(children).values;
  //   List<double> spacings = List.generate(children.length, (_) => 0);
  //   List<double> beatSpacing = toDivisionsSpacing();
  //   int? measureRestIndex;
  //   double lastAttributeOffset = 0;
  //   for (var entry in tValues.entries) {
  //     List<TimelineValue> beatCol = entry.value.sorted(
  //       (a, b) => a.voice.compareTo(b.voice),
  //     );

  //     int beat = entry.key.index;

  //     double attributeOffset = lastAttributeOffset;
  //     for (TimelineValue value in beatCol) {
  //       if (value.duration != 0) {
  //         // Check if the element is a measure rest and store its index
  //         if (children[value.index].tryAs<RestElement>()?.isMeasure == true) {
  //           measureRestIndex = value.index;
  //           break;
  //         }
  //         int beatIndex = beat.clamp(0, beatSpacing.length - 1);
  //         spacings[value.index] = beatSpacing[beatIndex];
  //       }

  //       if (value.duration == 0) {
  //         attributeOffset += 1;
  //         spacings[value.index] = attributeOffset;
  //         attributeOffset += value.width;
  //       }
  //     }
  //     if (values.elementAtOrNull(beat)?.lastAttributeOffset != null) {
  //       lastAttributeOffset = values[beat]!.lastAttributeOffset;
  //     }
  //     // Stop further processing if a measure rest has been found
  //     if (measureRestIndex != null) {
  //       break;
  //     }
  //   }

  //   // Calculate final spacing to mark measure width based on last beat offset.
  //   // and increase width for whole division.
  //   spacings.add(beatSpacing.last + spacePerDivision);

  //   if (measureRestIndex != null) {
  //     // Start the rest positioning from the first beat offset.
  //     double restPosition = beatSpacing[0];
  //     // Adjust rest to start after any initial attribute spacing.
  //     restPosition -= 1;
  //     // Move the rest to the center of the measure, between attribute end and barline or between two barlines.
  //     restPosition += (beatSpacing.last - restPosition) / 2;
  //     // Center-align the rest by adjusting for half of its width.
  //     restPosition -= children[measureRestIndex].baseSize.width / 2;
  //     spacings[measureRestIndex] = restPosition;
  //   }
  //   return spacings;
  // }

  // /// Computes the cumulative spacing for each division in the timeline, defining element positioning.
  // ///
  // /// This method calculates spatial offsets across the timeline’s beat divisions based on the
  // /// defined [_spaceBetweenQuarters] and [divisions], resulting in a list of cumulative spacing
  // /// values to guide element alignment.
  // ///
  // /// ### Returns:
  // /// A list of `double` values, where each value represents the cumulative offset at each beat division.
  // List<double> toDivisionsSpacing() {
  //   List<double> spacings = [];
  //   double lastAttributeOffset = 0;
  //   for (var (i, value) in values.indexed) {
  //     double spacingFromLeft = 0;

  //     if (lastAttributeOffset != value?.lastAttributeOffset && value != null) {
  //       spacingFromLeft += (value.lastAttributeOffset - lastAttributeOffset);
  //     }
  //     if (i != 0) {
  //       spacingFromLeft += spacePerDivision;
  //     }
  //     spacingFromLeft += spacings.lastOrNull ?? 0;

  //     spacings.add(spacingFromLeft);
  //     if (value != null) {
  //       lastAttributeOffset = value.lastAttributeOffset;
  //     }
  //   }
  //   return spacings;
  // }

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
          'Attributes before',
        ]
      ];

      for (var (i, val) in values.indexed) {
        List<String> col = [];

        String duration = val?.duration.toString() ?? " > ";
        if (val?.duration == 0) {
          duration = ">F>";
        }

        col.addAll([
          i.toString(),
          '----',
          duration,
          val?.attributesBefore.toString() ?? " > ",
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
class BeatlineValue {
  final int attributesBefore;

  // final double width;
  final double duration;

  const BeatlineValue({
    required this.duration,
    required this.attributesBefore,
  });

  /// Creates a copy of this BeatTimelineValue with optional new values for
  /// each field.
  BeatlineValue copyWith({
    double? duration,
    int? attributesBefore,
  }) {
    return BeatlineValue(
      duration: duration ?? this.duration,
      attributesBefore: attributesBefore ?? this.attributesBefore,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BeatlineValue &&
          runtimeType == other.runtimeType &&
          duration == other.duration &&
          attributesBefore == other.attributesBefore;

  @override
  int get hashCode => Object.hash(duration, attributesBefore);
}
