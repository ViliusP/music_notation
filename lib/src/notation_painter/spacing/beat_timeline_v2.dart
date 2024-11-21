part of 'timeline.dart';

/// Represents the timeline for rhythmic elements (notes, rests, chords) within a measure for a single voice.
class BeatTimelineV2 {
  /// Divisions per beat in the timeline, used to determine placement accuracy.
  final double divisions;

  /// Stores the beat values for each position in the timeline.
  /// Each element represents a beat position and may be `null` to indicate empty or unoccupied slots.
  final List<BeatTimelineValueV2?> values;

  /// Calculates the total duration covered by this timeline, summing all durations of non-null beats.
  double get duration => values.fold(
        0,
        (double duration, element) => duration + (element?.duration ?? 0),
      );

  /// Space between two quarter notes measured from their alignment axes.
  // static const double _spaceBetweenQuarters = 1.5;

  // double get spacePerDivision => _spaceBetweenQuarters / divisions;

  const BeatTimelineV2({
    required this.values,
    required this.divisions,
  });

  /// Creates a [BeatTimeline] from a [Timeline] and filters by a specified voice.
  ///
  /// Iterates through each value in the [timeline] and includes elements matching the specified [voice].
  /// Adjusts offsets for accurate beat placements.
  factory BeatTimelineV2.fromTimeline(MeasureTimeline timeline) {
    BeatTimelineV2? finalBeatline;

    for (var voice in timeline.uniqueVoices) {
      if ((int.tryParse(voice) ?? 0) > 0) {
        BeatTimelineV2 beatTimeline = BeatTimelineV2._fromVoiceTimeline(
          timeline: timeline,
          voice: voice,
        );
        finalBeatline ??= beatTimeline;
        finalBeatline = beatTimeline.combine(finalBeatline);
      }
    }
    return finalBeatline!;
  }

  /// Creates a [BeatTimelineV2] from a [MeasureTimeline] and filters by a specified voice.
  ///
  /// Iterates through each value in the [timeline] and includes elements matching the specified [voice].
  /// Adjusts offsets for accurate beat placements.
  factory BeatTimelineV2._fromVoiceTimeline({
    required MeasureTimeline timeline,
    required String voice,
  }) {
    int? parsedVoice = int.tryParse(voice);
    List<BeatTimelineValueV2> values = [];

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
          values.add(BeatTimelineValueV2(
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
    return BeatTimelineV2(
      values: values,
      divisions: timeline.divisions,
    ).normalize();
  }

  /// Combines this timeline with another [BeatTimeline] and returns a new timeline with adjusted values.
  ///
  /// Requires that both timelines have compatible `duration` and `divisions`.
  BeatTimelineV2 combine(BeatTimelineV2 other) {
    if (duration / divisions != other.duration / other.divisions) {
      throw ArgumentError(
        "Duration and divisions ratio of provided BeatTimeline is different",
        "other.duration",
      );
    }

    final List<BeatTimelineValueV2?> combined = [];

    BeatTimelineV2 bl1 = normalize();
    BeatTimelineV2 bl2 = other.normalize();
    // Ensure both timelines share the same number of divisions.
    if (bl1.divisions < bl2.divisions) {
      bl1 = bl1.changeDivisions(bl2.divisions);
    }
    if (bl2.divisions < bl1.divisions) {
      bl2 = bl2.changeDivisions(bl1.divisions);
    }

    BeatTimelineValueV2? lastAdded;

    for (int i = 0; i < bl1.values.length; i++) {
      BeatTimelineValueV2? bl1Value = bl1.values.elementAtOrNull(i);
      BeatTimelineValueV2? bl2Value = bl2.values.elementAtOrNull(i);

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
        combined.add(BeatTimelineValueV2(
          duration: [bl1Value.duration, bl2Value.duration].min,
          attributesBefore: [
            bl1Value.attributesBefore,
            bl2Value.attributesBefore,
          ].max,
        ));
        lastAdded = combined.last;
      }
    }

    return BeatTimelineV2(values: combined, divisions: bl1.divisions);
  }

  /// Changes the divisions of this timeline to the specified [value] and returns a new [BeatTimeline].
  ///
  /// The new divisions value must be greater than the current one.
  BeatTimelineV2 changeDivisions(double value) {
    if (value < divisions) {
      throw ArgumentError(
        "The new value of divisions must be bigger than the old value",
        "value",
      );
    }
    if (value == divisions) return this;
    double ratio = value / divisions;

    final List<BeatTimelineValueV2?> modified = List.generate(
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

    return BeatTimelineV2(values: modified, divisions: value);
  }

  /// Normalizes the timeline, ensuring each duration unit has a corresponding position, including `null` slots for rests.
  BeatTimelineV2 normalize() {
    final List<BeatTimelineValueV2?> normalized = [];
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
    return BeatTimelineV2(values: normalized, divisions: divisions);
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
class BeatTimelineValueV2 {
  final int attributesBefore;

  // final double width;
  final double duration;

  const BeatTimelineValueV2({
    required this.duration,
    required this.attributesBefore,
  });

  /// Creates a copy of this BeatTimelineValue with optional new values for
  /// each field.
  BeatTimelineValueV2 copyWith({
    double? duration,
    int? attributesBefore,
  }) {
    return BeatTimelineValueV2(
      duration: duration ?? this.duration,
      attributesBefore: attributesBefore ?? this.attributesBefore,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BeatTimelineValueV2 &&
          runtimeType == other.runtimeType &&
          duration == other.duration &&
          attributesBefore == other.attributesBefore;

  @override
  int get hashCode => Object.hash(duration, attributesBefore);
}
