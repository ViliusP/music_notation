part of 'timeline.dart';

/// For one voice.
class BeatTimeline {
  final double divisions;

  final List<BeatTimelineValue?> values;

  double get duration => values.fold(
        0,
        (double duration, element) => duration + (element?.duration ?? 0),
      );

  const BeatTimeline({
    required this.values,
    required this.divisions,
  });

  factory BeatTimeline.fromTimeline({
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
    return BeatTimeline(
      values: values,
      divisions: timeline.divisions,
    ).normalize();
  }

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

  BeatTimeline normalize() {
    final List<BeatTimelineValue?> normalized = [];
    int i = 0;
    for (final value in values) {
      if (value != null) {
        normalized.add(value);
        i++;
      }

      for (int j = 1; j < (value?.duration ?? 0); j++, i++) {
        normalized.add(null);
      }
    }
    return BeatTimeline(values: normalized, divisions: divisions);
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
        col.addAll([
          i.toString(),
          '----',
          val?.duration.toString() ?? "",
          val?.width.toString() ?? "",
          val?.leftOffset.toString() ?? "",
          val?.lastAttributeOffset.toString() ?? ""
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
