import 'dart:collection';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/rendering.dart';
import 'package:music_notation/music_notation.dart';
import 'package:music_notation/src/models/data_types/step.dart';
import 'package:music_notation/src/notation_painter/cursor_element.dart';
import 'package:music_notation/src/notation_painter/measure/measure_barlines.dart';
import 'package:music_notation/src/notation_painter/measure/measure_element.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/notes/rest_element.dart';
import 'package:music_notation/src/notation_painter/spacing/timeline.dart';
import 'package:music_notation/src/notation_painter/utilities/number_extensions.dart';
import 'package:music_notation/src/notation_painter/utilities/string_extensions.dart';

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
      var synced = _syncMeasureHeight(measure, i);
      syncedHeight.add(synced);
    }

    _values.add(syncedHeight);
  }

  List<MeasureGrid> _syncMeasuresWidth(List<MeasureGrid> measures) {
    List<MeasureGrid> synced = [];
    Beatline combined = measures.first.beatline;
    for (var measure in measures.skip(1)) {
      combined = combined.combine(measure.beatline);
    }
    for (var measure in measures) {
      var adjusted = measure.adjustByBeatline(combined);
      synced.add(adjusted);
    }

    return synced;
  }

  MeasureGrid _syncMeasureHeight(MeasureGrid measure, int staff) {
    var modifiedMeasure = measure.clone();
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

  static List<double> getHorizontalOffsets(
    List<MeasureGrid> measures,
  ) {
    if (measures.isEmpty) return [];

    List<ColumnIndex> indices =
        measures.firstOrNull?.columns.keys.toList() ?? [];
    double divisions = measures.firstOrNull?.beatline.divisions ?? 1;
    double defaultWidth =
        NotationLayoutProperties.baseWidthPerQuarter / divisions;

    var measureSections = MeasureGrid.toMeasureColumns(measures);

    /// First pass to get minimum beat size elements.
    /// And biggest (negative) left offset.
    double maxBeatWidth = defaultWidth;
    List<double> leftOffsets = [];
    for (var (i, columns) in measureSections.indexed) {
      leftOffsets.add(0);
      for (var cell in columns.expand((i) => i.cells.entries)) {
        if (indices[i].isRhytmic) {
          leftOffsets[i] = min(
            cell.value?.alignmentOffset.left ?? 0,
            leftOffsets[i],
          );
          maxBeatWidth = max(maxBeatWidth, cell.value?.size.width ?? 0);
        }
      }
    }

    List<double> offsets = [];
    double accumulatorOffset = NotationLayoutProperties.baseMeasurePadding;
    for (var (i, columns) in measureSections.indexed) {
      offsets.add(accumulatorOffset - leftOffsets[i].limit(top: 0));

      // Attribute element width depends on attribute size itself
      if (!indices[i].isRhytmic) {
        double width = 0;

        accumulatorOffset += NotationLayoutProperties.baseMeasurePadding;
        for (var cell in columns.expand((i) => i.cells.entries)) {
          if (cell.value != null) {
            width = max(width, cell.value!.size.width);
          }
        }
        accumulatorOffset += width;
      }
      // Rhythmic (with duration) element processing
      else {
        accumulatorOffset += maxBeatWidth;
      }
    }

    // Add last offset for width;
    accumulatorOffset += NotationLayoutProperties.baseMeasurePadding;
    offsets.add(accumulatorOffset);

    return offsets;
  }

  @override
  String toString() {
    int length = _values.elementAtOrNull(0)?.length ?? 0;

    List<List<String>> repr = List.generate(length, (_) => []);
    List<int> widths = List.generate(_values.length, (_) => 0);
    for (var (i, col) in _values.indexed) {
      for (var (j, measure) in col.indexed) {
        repr[j].add(
          "($j,$i) ↑${measure.heightAboveStave}↓${measure.heightBelowStave} ↔${measure.columns.length}",
        );
        widths[i] = max(widths[i], repr[j].last.length);
      }
    }

    String representation = "";
    for (var row in repr) {
      representation += "\n| ";

      for (var (j, col) in row.indexed) {
        representation += col.padLeft(widths[j]);
        representation += " | ";
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
  final List<MeasureElement> children;
  final MeasureBarlines barlines;
  final Beatline beatline;
  final MeasureTimeline _timeline;
  final int minHeightAbove;
  final int minHeightBelow;

  final SplayTreeMap<ColumnIndex, MeasureGridColumn> _columns;

  SplayTreeMap<ColumnIndex, MeasureGridColumn> get columns => _columns;

  /// Highest element position in whole measure.
  ElementPosition get minPosition => columns.values.last._cells.keys.last;

  /// Highest element position in whole measure.
  ElementPosition get maxPosition => columns.values.last.cells.keys.first;

  /// Reference position for stave bottom.
  ElementPosition get staveBottom => ElementPosition(step: Step.E, octave: 4);

  /// Reference position for stave top.
  ElementPosition get staveTop => ElementPosition(step: Step.F, octave: 5);

  bool get hasMeasureRest {
    var firstRhytmic = _columns.entries.firstWhereOrNull(
      (e) => e.key.isRhytmic,
    );
    var maybeMeasureRest = firstRhytmic?.value.cells.values.firstWhereOrNull(
      (v) => v?.child is RestElement && (v?.child as RestElement).isMeasure,
    );
    return maybeMeasureRest != null;
  }

  const MeasureGrid._({
    required this.children,
    required this.beatline,
    required this.barlines,
    required MeasureTimeline timeline,
    required SplayTreeMap<ColumnIndex, MeasureGridColumn> columns,
    this.minHeightAbove = 0,
    this.minHeightBelow = 0,
  })  : _timeline = timeline,
        _columns = columns;

  factory MeasureGrid.fromMeasureWidgets({
    required List<MeasureElement> children,
    required MeasureBarlines barlineSettings,
    required double divisions,
    int minHeightAbove = 0,
    int minHeightBelow = 0,
  }) {
    MeasureTimeline timeline = MeasureTimeline.fromMeasureElements(
      children,
      divisions,
    );
    Beatline beatline = Beatline.fromTimeline(timeline);

    SplayTreeMap<ColumnIndex, MeasureGridColumn> columns = SplayTreeMap.of({});
    int heightBelowStaff = minHeightBelow;
    int heightAboveStaff = minHeightAbove;

    int? attributes;
    int i = 0;

    for (var entry in timeline.values.entries) {
      List<TimelineValue> beatCol = entry.value.sorted(
        (a, b) => a.voice.compareTo(b.voice),
      );

      MeasureGridColumn col = MeasureGridColumn.fromHeights(
        heightAboveStave: minHeightAbove,
        heightBelowStave: minHeightBelow,
      );
      if (beatCol.isEmpty) {
        columns[ColumnIndex(i, attributes)] = col;
        i++;
      }

      for (var (j, value) in beatCol.indexed) {
        var position = children[value.index].position;

        if (value.duration == 0) {
          MeasureGridColumn col = MeasureGridColumn.fromHeights(
            heightAboveStave: minHeightAbove,
            heightBelowStave: minHeightBelow,
          );
          col.set(position, children[value.index]);

          attributes ??= 0;
          columns[ColumnIndex(i, attributes)] = col;
          attributes++;
        } else if (value.widgetType != CursorElement) {
          attributes = null;
          col.set(position, children[value.index]);
          if (j == beatCol.length - 1) {
            columns[ColumnIndex(i, attributes)] = col;
            i++;
          }
        }

        var elementHeightBelowStaff = position.distanceFromBottom
            .clamp(NumberConstants.minFiniteInt, 0)
            .abs();

        heightBelowStaff = [
          heightBelowStaff,
          elementHeightBelowStaff,
          (children[value.index].boxBelowStaff().height * 2).ceil(),
        ].max;

        var elementHeightAboveStaff = position.distanceFromTop.clamp(
          0,
          NumberConstants.maxFiniteInt,
        );

        heightAboveStaff = [
          heightAboveStaff,
          elementHeightAboveStaff,
          (children[value.index].boxAboveStaff().height * 2).ceil(),
        ].max;
      }
    }
    for (var e in columns.entries) {
      e.value.setHeightBelow(heightBelowStaff);
      e.value.setHeightAbove(heightAboveStaff);
    }

    return MeasureGrid._(
      barlines: barlineSettings,
      timeline: timeline,
      beatline: beatline,
      children: children,
      minHeightAbove: heightAboveStaff,
      minHeightBelow: heightBelowStaff,
      columns: columns,
    );
  }

  int get heightAboveStave {
    var highestPosition = _columns.values.last._cells.keys.firstOrNull;
    highestPosition ??= ElementPosition.staffTop;

    int distance = ElementPosition.staffTop.distance(highestPosition);

    return distance.clamp(0, NumberConstants.maxFiniteInt);
  }

  int get heightBelowStave {
    var lowestPosition = _columns.values.last._cells.keys.lastOrNull;
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
    int rows = _columns.entries.elementAtOrNull(0)?.value._cells.length ?? 0;

    List<List<String>> representationGrid = List.generate(rows + 1, (_) => []);

    // Add header
    representationGrid[0].add("p");
    for (var key in _columns.keys) {
      representationGrid[0].add(key.toString());
    }

    /// Add values to grid
    for (var (i, entry) in _columns.entries.indexed) {
      for (var (j, colValue) in entry.value._cells.entries.indexed) {
        if (i == 0) {
          representationGrid[j + 1].add("${colValue.key.numeric}");
        }
        if (colValue.value != null) {
          representationGrid[j + 1].add(
            "${colValue.key.step}${colValue.key.octave}",
          );
        }
        if (colValue.value == null) {
          representationGrid[j + 1].add("");
        }
      }
    }

    // Calculates column widths
    List<int> widths = [];
    for (var row in representationGrid) {
      for (var (i, cell) in row.indexed) {
        if (widths.elementAtOrNull(i) == null) {
          widths.add(cell.length);
        }
        widths[i] = max(widths[i], cell.length);
      }
    }

    // Convert grid to string representation
    String repr = "\n";
    for (var row in representationGrid) {
      for (var (i, cell) in row.indexed) {
        repr += "|${cell.padCenter(widths[i] + 2)}";
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

  MeasureGrid clone() {
    return MeasureGrid._(
      children: children,
      barlines: barlines,
      minHeightAbove: minHeightAbove,
      minHeightBelow: minHeightBelow,
      beatline: beatline,
      timeline: _timeline,
      columns: _columns,
    );
  }

  MeasureGrid adjustByBeatline(Beatline beatline) {
    if (beatline == this.beatline) {
      return this;
    }
    var adjusted = SplayTreeMap<ColumnIndex, MeasureGridColumn>.of({});
    var emptyCol = MeasureGridColumn.fromHeights(
      heightAboveStave: heightAboveStave,
      heightBelowStave: heightBelowStave,
    );
    double ratio = beatline.divisions / this.beatline.divisions;
    int beat = 0;
    int attributes = 0;
    int lastAttribute = 0;

    for (var e in _columns.entries) {
      var index = e.key;
      var column = e.value;
      if (index.isRhytmic) {
        // If other beatlines has additional attributes, it should be added before beat note.
        int attributesToAdd =
            beatline.values[beat].attributesBefore - attributes;
        for (int i = 0; i < attributesToAdd; i++) {
          attributes++;
          adjusted[ColumnIndex(beat, lastAttribute + i)] = emptyCol;
        }
        lastAttribute = 0;

        // Add existing beat column (column with notes)
        adjusted[ColumnIndex(beat, null)] = column;
        beat++;

        // Add empty columns to increase division
        for (int i = 1; i < ratio; i++) {
          adjusted[ColumnIndex(beat, null)] = emptyCol;
          beat++;
        }
      } else {
        // Add attributes, it has no duration, so no additional columns are added
        adjusted[ColumnIndex(beat, index.attributeNumber)] = column;
        lastAttribute = index.attributeNumber!;
        attributes++;
      }
    }

    return MeasureGrid._(
      children: children,
      beatline: beatline,
      barlines: barlines,
      timeline: _timeline,
      columns: adjusted,
      minHeightAbove: minHeightAbove,
      minHeightBelow: minHeightBelow,
    );
  }
}

class MeasureGridColumn {
  final SplayTreeMap<ElementPosition, MeasureElement?> _cells;
  SplayTreeMap<ElementPosition, MeasureElement?> get cells => _cells;

  MeasureGridColumn()
      : _cells = SplayTreeMap.of({
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
      if (!_cells.containsKey(ElementPosition.fromInt(i))) {
        _cells[ElementPosition.fromInt(i)] = null;
      }
    }
  }

  void setHeightBelow(int height) {
    int start = ElementPosition.staffBottom.numeric;

    for (int i = start - height; i < start; i++) {
      if (!_cells.containsKey(ElementPosition.fromInt(i))) {
        _cells[ElementPosition.fromInt(i)] = null;
      }
    }
  }

  void set(ElementPosition position, MeasureElement? widget) {
    _cells[position] = widget;
  }

  @override
  String toString() {
    String value = "\n";

    for (var e in _cells.entries) {
      value += "${e.key.numeric} ${e.key.step}${e.key.octave}: ${e.value}";
      value += "\n";
    }
    return value;
  }
}

class ColumnIndex implements Comparable<ColumnIndex> {
  final int beat;
  final int? attributeNumber;
  bool get isRhytmic => attributeNumber == null;

  ColumnIndex(
    this.beat, [
    this.attributeNumber,
  ]) : assert(attributeNumber == null || attributeNumber >= 0);

  @override
  int compareTo(ColumnIndex other) {
    if (beat == other.beat) {
      return (attributeNumber ?? NumberConstants.maxFiniteInt)
          .compareTo(other.attributeNumber ?? NumberConstants.maxFiniteInt);
    }
    return beat.compareTo(other.beat);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ColumnIndex &&
          runtimeType == other.runtimeType &&
          beat == other.beat &&
          attributeNumber == other.attributeNumber;

  @override
  int get hashCode => Object.hash(beat, attributeNumber);

  @override
  String toString() => "$beat${"*" * ((attributeNumber ?? -1) + 1)}";
}
