part of 'timeline.dart';

/// Represents the timeline for rhythmic elements (notes, rests, chords) within a measure for a single voice.
class Beatline {
  /// Divisions per beat in the timeline, used to determine placement accuracy.
  final double divisions;

  /// Stores the beat values for each position in the timeline.
  /// Each element represents a beat position and may be `null` to indicate empty or unoccupied slots.
  final List<BeatlineValue> values;

  /// Calculates the total duration covered by this timeline, summing all durations of non-null beats.
  final double duration;

  const Beatline({
    required this.values,
    required this.divisions,
    required this.duration,
  });

  /// Creates a [BeatTimeline] from a [Timeline] and filters by a specified voice.
  ///
  /// Iterates through each value in the [timeline] and includes elements matching the specified [voice].
  /// Adjusts offsets for accurate beat placements.
  factory Beatline.fromTimeline(MeasureTimeline timeline) {
    List<BeatlineValue> values = [];

    int attributes = 0;
    int beat = 0;
    for (var entry in timeline.values.entries) {
      List<TimelineValue> beatCol = entry.value.sorted(
        (a, b) => a.voice.compareTo(b.voice),
      );
      if (entry.value.isEmpty) {
        values.add(BeatlineValue(
          beat: beat.toDouble(),
          attributesBefore: attributes,
        ));
        beat++;
      }

      for (TimelineValue value in beatCol) {
        if (value.duration == 0) {
          attributes++;
        }
        if (value.widgetType == CursorElement) {
          continue;
        }
        if (value.duration != 0) {
          values.add(BeatlineValue(
            beat: beat.toDouble(),
            attributesBefore: attributes,
          ));
          beat++;
          break;
        }
      }
    }

    int duration = timeline.values.keys.lastWhere((k) => k.isRhytmic).index;
    duration++;

    if (duration < 0) duration = 0;

    return Beatline(
      values: values,
      divisions: timeline.divisions,
      duration: duration.toDouble(),
    );
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

    final List<BeatlineValue> combined = [];

    Beatline bl1 = this;
    Beatline bl2 = other;

    // Ensure both timelines share the same number of divisions.
    if (bl1.divisions < bl2.divisions) {
      bl1 = bl1.changeDivisions(bl2.divisions);
    }
    if (bl2.divisions < bl1.divisions) {
      bl2 = bl2.changeDivisions(bl1.divisions);
    }

    for (int i = 0; i < bl1.values.length; i++) {
      BeatlineValue bl1Value = bl1.values.elementAt(i);
      BeatlineValue bl2Value = bl2.values.elementAt(i);

      combined.add(BeatlineValue(
        beat: i.toDouble(),
        attributesBefore: [
          bl1Value.attributesBefore,
          bl2Value.attributesBefore,
        ].max,
      ));
    }
    // print("After everything: ${bl1.duration}");
    return Beatline(
      values: combined,
      divisions: bl1.divisions,
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

    final List<BeatlineValue> modified = [];

    int i = 0;
    for (final value in values) {
      for (int j = 0; j < ratio; j++) {
        modified.add(BeatlineValue(
          beat: i.toDouble(),
          attributesBefore: value.attributesBefore,
        ));
        i++;
      }
    }

    return Beatline(
      values: modified,
      divisions: value,
      duration: duration * ratio,
    );
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
          '-----------------',
          'Attributes before',
        ]
      ];

      for (var val in values) {
        List<String> col = [];

        col.addAll([
          val.beat.toString(),
          '----',
          val.attributesBefore.toString(),
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
  final double beat;

  const BeatlineValue({
    required this.beat,
    required this.attributesBefore,
  });

  /// Creates a copy of this BeatTimelineValue with optional new values for
  /// each field.
  BeatlineValue copyWith({
    double? beat,
    int? attributesBefore,
  }) {
    return BeatlineValue(
      beat: beat ?? this.beat,
      attributesBefore: attributesBefore ?? this.attributesBefore,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BeatlineValue &&
          runtimeType == other.runtimeType &&
          beat == other.beat &&
          attributesBefore == other.attributesBefore;

  @override
  int get hashCode => Object.hash(beat, attributesBefore);
}
