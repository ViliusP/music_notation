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
