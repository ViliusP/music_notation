part of 'timeline.dart';

/// For one voice.
class BeatTimeline {
  final double divisions;

  final List<BeatTimelineValue> values;

  BeatTimeline._({
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
          lastAttributeOffset = 0;
        }
        // names[value.index] = value.name;

        // if (value.duration == 0) {
        //   spacings[value.index] = measureStartMargin;
        //   spacings[value.index] += NotationLayoutProperties.staveSpace;
        //   if (valueBefore != null) {
        //     spacings[value.index] += valueBefore.width;
        //   }
        //   measureStartMargin = spacings[value.index];
        // }

        // if (value.duration != 0) {
        //   if (isMeasureStart) {
        //     measureStartMargin += valueBefore?.width ?? 0;
        //     measureStartMargin += NotationLayoutProperties.staveSpace;
        //     isMeasureStart = false;
        //   }
        //   double leftOffset = measureStartMargin + (beat * spacePerBeat);

        //   spacings[value.index] = leftOffset;
        // }

        // if (biggestOffset < spacings[value.index]) {
        //   biggestOffset = spacings[value.index];
        //   biggestOffsetElement = value;
        // }
        // valueBefore = value;
      }
    }
    return BeatTimeline._(values: values, divisions: timeline.divisions);
  }

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
          val.duration.toString(),
          val.width.toString(),
          val.leftOffset.toString(),
          val.lastAttributeOffset.toString()
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

  BeatTimelineValue({
    required this.width,
    required this.leftOffset,
    required this.duration,
    required this.lastAttributeOffset,
  });
}
