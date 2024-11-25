import 'dart:collection';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:music_notation/src/notation_painter/measure/barline_painting.dart';
import 'package:music_notation/src/notation_painter/measure/measure_element.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/spacing/timeline.dart';
import 'package:music_notation/src/notation_painter/utilities/number_extensions.dart';

class MusicSheetGrid {
  /// Outer list represents measure location horizontally (measure number), inner list represents stave position.
  final List<List<MeasureGrid>> _values;
  List<List<MeasureGrid>> get values => _values;

  final int staves;

  MusicSheetGrid(this.staves) : _values = [];

  void add(List<MeasureGrid> column) {
    if (staves != column.length) {
      throw ArgumentError(
        "Provided measures has bigger size than grid has staves",
      );
    }

    List<MeasureGrid> syncedWidth = _syncMeasuresWidth(column);
    List<MeasureGrid> syncedHeight = [];
    for (var (i, measure) in syncedWidth.indexed) {
      syncedHeight.add(_syncMeasureHeight(measure, i));
    }

    _values.add(syncedHeight);
  }

  List<MeasureGrid> _syncMeasuresWidth(List<MeasureGrid> measures) {
    return List.from(measures, growable: false);
  }

  MeasureGrid _syncMeasureHeight(MeasureGrid measure, int staff) {
    var modifiedMeasure = measure.copyWith();
    if (_values.isEmpty) {
      return modifiedMeasure;
    }

    var lastStaffMeasure = _values.last[staff];
    int currentHeightAboveStave = lastStaffMeasure.heightAboveStave;
    int currentHeightBelowStave = lastStaffMeasure.heightBelowStave;

    if (currentHeightAboveStave > measure.heightAboveStave) {
      modifiedMeasure.setHeightAbove(currentHeightAboveStave);
    }
    if (currentHeightAboveStave < measure.heightAboveStave) {
      _setHeightAbove(measure.heightAboveStave, staff);
    }
    if (currentHeightBelowStave > measure.heightBelowStave) {
      modifiedMeasure.setHeightBelow(currentHeightBelowStave);
    }
    if (currentHeightBelowStave < measure.heightBelowStave) {
      _setHeightBelow(measure.heightBelowStave, staff);
    }

    return modifiedMeasure;
  }

  void _setHeightAbove(int height, int staff) {
    for (var measureCol in _values) {
      measureCol[staff].setHeightAbove(height);
    }
  }

  void _setHeightBelow(int height, int staff) {
    for (var measureCol in _values) {
      measureCol[staff].setHeightBelow(height);
    }
  }

  @override
  String toString() {
    int length = _values.elementAtOrNull(0)?.length ?? 0;

    List<List<String>> repr = List.generate(length, (_) => []);
    for (var (i, col) in _values.indexed) {
      for (var (j, _) in col.indexed) {
        repr[j].add("($j,$i)");
      }
    }

    String representation = "";
    for (var row in repr) {
      int colWidth = row.elementAtOrNull(0)?.length ?? 0;
      representation += "\n| ";

      for (var col in row) {
        colWidth = max(colWidth, col.length);
      }
      for (var col in row) {
        representation += "$col | ".padLeft(colWidth);
      }
    }

    return representation;
  }
}

/// Visual representation
///
/// ```text
///   0   1   2   3   column
/// ==-===-===-===-== F5  (38)
/// | - | - | - | - | E5  (37)
/// ==-===-===-===-== D5
/// | - | - | - | - | C5
/// ==-===-===-===-== B4
/// | - | - | - | - | A4
/// ==-===-===-===-== G4
/// | - | - | - | - | F4  (31)
/// ==-===-===-===-== E3  (30)
///                   Row (index)
/// ```
///
/// `=` - represents staff line and cell's top/bottom boundary.\
/// `-` - represents position.\
/// `|` - cell vertical and cell's left/right boundary
class MeasureGrid {
  final List<MeasureWidget> _children;
  final BarlineSettings _barlineSettings;
  final BeatTimelineV2 _beatTimelineV2;
  final MeasureTimeline _timeline;
  final int minHeightAbove;
  final int minHeightBelow;

  final SplayTreeMap<ColumnIndex, MeasureGridColumn> _columns;

  SplayTreeMap<ColumnIndex, MeasureGridColumn> get columns => _columns;

  const MeasureGrid._({
    required List<MeasureWidget> children,
    required BeatTimelineV2 beatTimelineV2,
    required BarlineSettings barlineSettings,
    required MeasureTimeline timeline,
    required SplayTreeMap<ColumnIndex, MeasureGridColumn> columns,
    this.minHeightAbove = 0,
    this.minHeightBelow = 0,
  })  : _beatTimelineV2 = beatTimelineV2,
        _barlineSettings = barlineSettings,
        _timeline = timeline,
        _columns = columns,
        _children = children;

  factory MeasureGrid.fromMeasureWidgets({
    required List<MeasureWidget> children,
    required BarlineSettings barlineSettings,
    int minHeightAbove = 0,
    int minHeightBelow = 0,
  }) {
    MeasureTimeline timeline = MeasureTimeline.fromMeasureElements(children);
    BeatTimelineV2 beatTimeline = BeatTimelineV2.fromTimeline(timeline);

    SplayTreeMap<ColumnIndex, MeasureGridColumn> columns = SplayTreeMap.of({});
    int heightBelowStaff = minHeightBelow;
    int heightAboveStaff = minHeightAbove;
    int count = 0;
    for (var entry in timeline.values.entries) {
      List<TimelineValue> beatCol = entry.value.sorted(
        (a, b) => a.voice.compareTo(b.voice),
      );

      MeasureGridColumn col = MeasureGridColumn.fromHeights(
        heightAboveStave: minHeightAbove,
        heightBelowStave: minHeightBelow,
      );

      for (var (i, value) in beatCol.indexed) {
        var position = children[value.index].position;

        if (value.duration == 0) {
          MeasureGridColumn col = MeasureGridColumn.fromHeights(
            heightAboveStave: minHeightAbove,
            heightBelowStave: minHeightBelow,
          );
          col.set(position, children[value.index]);

          columns[ColumnIndex(count, false)] = col;
          count++;
        } else {
          col.set(position, children[value.index]);
          if (i == beatCol.length - 1) {
            columns[ColumnIndex(count, true)] = col;
            count++;
          }
        }

        var elementHeightBelowStaff = position.distanceFromBottom
            .clamp(NumberConstants.minFiniteInt, 0)
            .abs();

        heightBelowStaff = [
          heightBelowStaff,
          elementHeightBelowStaff,
          children[value.index].boxBelowStaff().height.ceil() * 2,
        ].max;

        var elementHeightAboveStaff = position.distanceFromTop.clamp(
          0,
          NumberConstants.maxFiniteInt,
        );

        heightAboveStaff = [
          heightAboveStaff,
          elementHeightAboveStaff,
          children[value.index].boxAboveStaff().height.ceil() * 2,
        ].max;
      }
    }
    for (var e in columns.entries) {
      e.value.setHeightBelow(heightBelowStaff);
      e.value.setHeightAbove(heightAboveStaff);
    }

    return MeasureGrid._(
      barlineSettings: barlineSettings,
      timeline: timeline,
      beatTimelineV2: beatTimeline,
      children: children,
      minHeightAbove: minHeightBelow,
      minHeightBelow: minHeightBelow,
      columns: columns,
    );
  }

  int get heightAboveStave {
    var highestPosition = _columns.values.first._values.keys.firstOrNull;
    highestPosition ??= ElementPosition.staffTop;

    int distance = ElementPosition.staffTop.distance(highestPosition);

    return distance.clamp(0, NumberConstants.maxFiniteInt);
  }

  int get heightBelowStave {
    var lowestPosition = _columns.values.first._values.keys.firstOrNull;
    lowestPosition ??= ElementPosition.staffBottom;

    int distance = ElementPosition.staffBottom.distance(lowestPosition);

    return distance.clamp(0, NumberConstants.maxFiniteInt);
  }

  static List<List<MeasureGridColumn>> toMeasureColumns(
    List<MeasureGrid> measures,
  ) {
    final int maxLength = measures
        .map((list) => list.columns.entries.length)
        .reduce((a, b) => a > b ? a : b);
    return List.generate(
      maxLength,
      (col) => measures.map((row) => row.columns.values.toList()[col]).toList(),
    );
  }

  @override
  String toString() {
    int rows = _columns.entries.elementAtOrNull(0)?.value._values.length ?? 0;

    List<List<String>> representationGrid = List.generate(rows, (_) => []);

    for (var (i, entry) in _columns.entries.indexed) {
      print(entry.value._values.length);
      for (var (j, colValue) in entry.value._values.entries.indexed) {
        if (i == 0) {
          representationGrid[j].add("${colValue.key.numeric}");
        }
        if (colValue.value != null) {
          representationGrid[j].add(
            "${colValue.key.step}${colValue.key.octave}",
          );
        }
        if (colValue.value == null) {
          representationGrid[j].add("  ");
        }
      }
    }
    String repr = "\n";
    for (var col in representationGrid) {
      for (var row in col) {
        repr += "| ${row} ";
      }
      repr += "|\n";
    }

    return repr;
  }

  void setHeightBelow(int height) {
    for (var e in _columns.entries) {
      e.value.setHeightBelow(height);
    }
  }

  void setHeightAbove(int height) {
    for (var e in _columns.entries) {
      e.value.setHeightAbove(height);
    }
  }

  MeasureGrid copyWith() {
    return MeasureGrid.fromMeasureWidgets(
      children: _children,
      barlineSettings: _barlineSettings,
      minHeightAbove: minHeightAbove,
      minHeightBelow: minHeightBelow,
    );
  }
}

class MeasureGridColumn {
  final SplayTreeMap<ElementPosition, MeasureWidget?> _values;
  SplayTreeMap<ElementPosition, MeasureWidget?> get values => _values;

  MeasureGridColumn()
      : _values = SplayTreeMap.of({
          ElementPosition.staffBottom.transpose(0): null,
          ElementPosition.staffBottom.transpose(1): null,
          ElementPosition.staffBottom.transpose(2): null,
          ElementPosition.staffBottom.transpose(3): null,
          ElementPosition.staffBottom.transpose(4): null,
          ElementPosition.staffBottom.transpose(5): null,
          ElementPosition.staffBottom.transpose(6): null,
          ElementPosition.staffBottom.transpose(7): null,
          ElementPosition.staffBottom.transpose(8): null, // Staff top
        }, (a, b) => b.compareTo(a));

  factory MeasureGridColumn.fromHeights({
    int heightAboveStave = 0,
    int heightBelowStave = 0,
  }) {
    return MeasureGridColumn()
      ..setHeightAbove(heightAboveStave)
      ..setHeightBelow(heightBelowStave);
  }

  void setHeightAbove(int height) {
    int start = ElementPosition.staffTop.numeric;

    for (int i = start + 1; i < start + height + 1; i++) {
      if (!_values.containsKey(ElementPosition.fromInt(i))) {
        _values[ElementPosition.fromInt(i)] = null;
      }
    }
  }

  void setHeightBelow(int height) {
    int start = ElementPosition.staffBottom.numeric;

    for (int i = start - height; i < start; i++) {
      if (!_values.containsKey(ElementPosition.fromInt(i))) {
        _values[ElementPosition.fromInt(i)] = null;
      }
    }
  }

  void set(ElementPosition position, MeasureWidget? widget) {
    _values[position] = widget;
  }

  @override
  String toString() {
    String value = "\n";

    for (var e in _values.entries) {
      value += "${e.key.numeric} ${e.key.step}${e.key.octave}: ${e.value}";
      value += "\n";
    }
    return value;
  }
}

class ColumnIndex implements Comparable<ColumnIndex> {
  final int value;
  final bool isRhytmic;

  ColumnIndex(
    this.value, [
    this.isRhytmic = true,
  ]);

  @override
  int compareTo(ColumnIndex other) {
    if (value != other.value) {
      return value.compareTo(other.value); // Compare by value first
    }
    return isRhytmic == other.isRhytmic
        ? 0
        : (isRhytmic ? 1 : -1); // `isRhytmic` as secondary comparison
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ColumnIndex &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          isRhytmic == other.isRhytmic;

  @override
  int get hashCode => Object.hash(value, isRhytmic);

  @override
  String toString() => "$value${!isRhytmic ? "*" : ""}";
}
