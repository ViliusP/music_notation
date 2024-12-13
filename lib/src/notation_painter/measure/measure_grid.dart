import 'dart:collection';
import 'dart:math';

import 'package:collection/collection.dart';
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

/// Represents a grid-like structure of measures in a musical sheet,
/// organized by columns. Each column corresponds to a specific measure
/// number across all staves.
///
/// For example:
/// - The first column (index 0) contains the first measures of all staves.
/// - The second column (index 1) contains the second measures of all staves, and so on.
class MusicSheetGrid {
  /// A grid of measures organized by columns, where each column represents
  /// a specific measure number across all staves.
  /// - Outer `List` - Columns of the music sheet, indexed by measure number.
  /// - Inner `List` - Measures of all staves for the specific column (measure number).
  final List<MeasuresColumn> _columns;
  List<MeasuresColumn> get columns => _columns;

  /// The number of staves in the music sheet.
  final int staves;

  /// Constructor to initialize the music sheet grid with the given number of staves.
  MusicSheetGrid(this.staves) : _columns = [];

  void add(MeasuresColumn column) {
    if (staves != column.measures.length) {
      throw ArgumentError("Provided column has different size than the grid");
    }

    for (int i = 0; i < column.measures.length; i++) {
      _syncMeasureHeight(column, i);
    }

    _columns.add(column);
  }

  void _syncMeasureHeight(MeasuresColumn column, int staff) {
    if (_columns.isEmpty) {
      return;
    }

    var columnToCheck = column.measures[staff];

    var lastGridMeasure = _columns.last.measures[staff];
    var currentCeil = lastGridMeasure.ceil;
    var currentFloor = lastGridMeasure.floor;

    if (currentCeil > columnToCheck.ceil) {
      column.setCeil(position: currentCeil, stave: staff);
    }
    if (currentCeil < columnToCheck.ceil) {
      _setCeil(position: columnToCheck.ceil, stave: staff);
    }
    if (currentFloor > columnToCheck.floor) {
      _setFloor(position: columnToCheck.floor, stave: staff);
    }
    if (currentFloor < columnToCheck.floor) {
      column.setFloor(position: currentFloor, stave: staff);
    }

    return;
  }

  void _setCeil({required ElementPosition position, required int stave}) {
    for (var column in _columns) {
      column.setCeil(position: position, stave: stave);
    }
  }

  void _setFloor({required ElementPosition position, required int stave}) {
    for (var column in _columns) {
      column.setFloor(position: position, stave: stave);
    }
  }

  @override
  String toString() {
    int length = _columns.elementAtOrNull(0)?.measures.length ?? 0;

    List<List<String>> repr = List.generate(length, (_) => []);
    List<int> widths = List.generate(_columns.length, (_) => 0);
    for (var (i, column) in _columns.indexed) {
      for (var (j, measure) in column._measures.indexed) {
        repr[j].add(
          "($j,$i) ↑${measure.ceil}↑ ↓${measure.floor}↓ ↔${measure.columns.length}↔",
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

class MeasuresColumn {
  List<MeasureGrid> _measures;

  MeasuresColumn._({
    required List<MeasureGrid> measures,
  }) : _measures = measures;

  MeasuresColumn.empty() : _measures = [];

  List<MeasureGrid> get measures => _measures;

  SplayTreeMap<ColumnIndex, List<MeasureElement>> get _combined {
    SplayTreeMap<ColumnIndex, List<MeasureElement>> combined =
        SplayTreeMap.of({});

    for (var measure in _measures) {
      for (var e in measure.columns.entries) {
        var key = e.key;
        var column = e.value;
        combined[key] ??= [];
        combined[key]!.addAll(column.cells.values.nonNulls);
      }
    }
    return combined;
  }

  List<MeasureGrid> _syncWidth(List<MeasureGrid> measures) {
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

  List<double> get horizontalOffsets {
    if (measures.isEmpty) return [];

    /// First pass to get minimum beat size elements.
    /// And biggest (negative) left offset.

    List<double> leftOffsets = [];

    double maxBeatWidth = 0;

    int i = -1;
    // Looping through every key horizontally ->
    for (var key in _combined.keys) {
      i++;
      leftOffsets.add(0);

      // Looping trough every staff measure to take whole column of widgets.
      for (var measure in measures) {
        // Looping through cell in single measure column (section).
        for (var cell in measure.columns[key]!.cells.values) {
          leftOffsets[i] = min(
            cell.offset.left,
            leftOffsets[i],
          );

          if (key.isRhytmic) {
            double a = cell.duration;
            if (a != 0) {
              double cellWidth = cell.size.width;

              // if (a != 0) {
              //   print("Divisions ${divisions}");
              //   print("Duration ${cell.value?.duration}");
              //   print("Cell size: ${cell.value?.size.width ?? 0}");
              //   print("New width: ${cellWidth}");
              // }
              maxBeatWidth = max(maxBeatWidth, cellWidth);
            }
          }
        }
      }
    }

    List<double> offsets = [];
    double accumulatorOffset = NotationLayoutProperties.baseMeasurePadding;
    for (var e in _combined.entries) {
      var cells = e.value;
      var key = e.key;
      offsets.add(accumulatorOffset - leftOffsets[i].limit(top: 0));

      // Attribute element width depends on attribute size itself
      if (!key.isRhytmic) {
        double width = 0;

        accumulatorOffset += NotationLayoutProperties.baseMeasurePadding;
        for (var cell in cells) {
          width = max(width, cell.size.width);
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

  void add(MeasureGrid measure) {
    List<MeasureGrid> synced = _syncWidth([
      measure,
      ...measures,
    ]);

    _measures = synced;
  }

  void addAll(List<MeasureGrid> measures) {
    List<MeasureGrid> synced = _syncWidth([
      ...measures,
      ...this.measures,
    ]);

    _measures = synced;
  }

  void setCeil({required int stave, required ElementPosition position}) {
    measures[stave]._setCeil(position);
  }

  void setFloor({required int stave, required ElementPosition position}) {
    measures[stave]._setFloor(position);
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

  final SplayTreeMap<ColumnIndex, MeasureGridColumn> _columns;

  SplayTreeMap<ColumnIndex, MeasureGridColumn> get columns => _columns;

  /// Reference position for stave bottom.
  ElementPosition get staveBottom => ElementPosition(step: Step.E, octave: 4);

  /// Reference position for stave top.
  ElementPosition get staveTop => ElementPosition(step: Step.F, octave: 5);

  bool get hasMeasureRest {
    var firstRhytmic = _columns.entries.firstWhereOrNull(
      (e) => e.key.isRhytmic,
    );
    var maybeMeasureRest = firstRhytmic?.value.cells.values.firstWhereOrNull(
      (v) => v.child is RestElement && (v.child as RestElement).isMeasure,
    );
    return maybeMeasureRest != null;
  }

  const MeasureGrid._({
    required this.children,
    required this.beatline,
    required this.barlines,
    required MeasureTimeline timeline,
    required SplayTreeMap<ColumnIndex, MeasureGridColumn> columns,
  })  : _timeline = timeline,
        _columns = columns;

  factory MeasureGrid.fromMeasureElements({
    required List<MeasureElement> children,
    required MeasureBarlines barlines,
    required double divisions,
  }) {
    MeasureTimeline timeline = MeasureTimeline.fromMeasureElements(
      children,
      divisions,
    );
    Beatline beatline = Beatline.fromTimeline(timeline);

    SplayTreeMap<ColumnIndex, MeasureGridColumn> columns = SplayTreeMap.of({});
    ElementPosition floor = ElementPosition.staffBottom;
    ElementPosition ceil = ElementPosition.staffTop;

    int? attributes;
    int i = 0;

    for (var entry in timeline.values.entries) {
      List<TimelineValue> beatCol = entry.value.sorted(
        (a, b) => a.voice.compareTo(b.voice),
      );

      MeasureGridColumn col = MeasureGridColumn()
        .._setFloor(floor)
        .._setCeil(ceil);
      if (beatCol.isEmpty) {
        columns[ColumnIndex(i, attributes)] = col;
        i++;
      }

      for (var (j, value) in beatCol.indexed) {
        var child = children[value.index];
        var position = child.position;

        if (value.duration == 0) {
          MeasureGridColumn col = MeasureGridColumn()
            .._setFloor(floor)
            .._setCeil(ceil);

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

        var bounds = child.bounds;

        floor = [floor, bounds.min, bounds.max].min;
        ceil = [ceil, bounds.min, bounds.max].max;
      }
    }
    for (var e in columns.entries) {
      e.value._setFloor(floor);

      e.value._setCeil(ceil);
    }

    return MeasureGrid._(
      barlines: barlines,
      timeline: timeline,
      beatline: beatline,
      children: children,
      columns: columns,
    );
  }

  ElementPosition get ceil {
    return _columns.values.map((value) => value.ceil).maxOrNull ??
        ElementPosition.staffBottom;
  }

  ElementPosition get floor {
    return _columns.values.map((value) => value.floor).minOrNull ??
        ElementPosition.staffBottom;
  }

  void _setFloor(ElementPosition position) {
    for (var e in _columns.entries) {
      e.value._setFloor(position);
    }
  }

  void _setCeil(ElementPosition position) {
    for (var e in _columns.entries) {
      e.value._setCeil(position);
    }
  }

  MeasureGrid adjustByBeatline(Beatline beatline) {
    if (beatline == this.beatline) {
      return this;
    }
    var adjusted = SplayTreeMap<ColumnIndex, MeasureGridColumn>.of({});
    var emptyCol = MeasureGridColumn()
      .._setFloor(floor)
      .._setCeil(ceil);

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
    );
  }

  MeasureGrid clone() {
    return MeasureGrid._(
      children: children,
      barlines: barlines,
      beatline: beatline,
      timeline: _timeline,
      columns: _columns,
    );
  }

  @override
  String toString() {
    int rows = (ceil.numeric - floor.numeric) + 1;

    List<List<String>> representationGrid = List.generate(rows + 1, (_) => []);

    // Add header
    representationGrid[0].add("p");
    for (var key in _columns.keys) {
      representationGrid[0].add(key.toString());
    }

    /// Add values to grid
    for (var (i, e) in _columns.entries.indexed) {
      var column = e.value;
      for (int j = rows - 1; j >= 0; j--) {
        var pos = ceil - j;
        var cell = column.cells[pos];
        if (i == 0) {
          representationGrid[j + 1].add("${pos.numeric}");
        }
        if (cell != null) {
          representationGrid[j + 1].add(
            "${cell.position.step}${cell.position.octave}",
          );
        }
        if (cell == null) {
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

class MeasureGridColumn {
  final SplayTreeMap<ElementPosition, MeasureElement> _cells;
  SplayTreeMap<ElementPosition, MeasureElement> get cells => _cells;

  ElementPosition _ceil;
  ElementPosition get ceil => _ceil;

  ElementPosition _floor;
  ElementPosition get floor => _floor;

  MeasureGridColumn()
      : _cells = SplayTreeMap.of({}, (a, b) => b.compareTo(a)),
        _floor = ElementPosition.staffBottom,
        _ceil = ElementPosition.staffBottom.transpose(8);

  void _setCeil(ElementPosition position) {
    if (position >= _ceil) {
      _ceil = position;
      return;
    }
    if (position < _floor) {
      return;
    }
    for (ElementPosition p = _ceil - 1; p > _floor; p--) {
      if (_cells[p] != null) {
        break;
      }
      _ceil = p;
    }
  }

  void _setFloor(ElementPosition position) {
    if (position <= _floor) {
      _floor = position;
      return;
    }
    if (position > _ceil) {
      return;
    }
    for (ElementPosition p = _floor + 1; p < _ceil; p++) {
      if (_cells[p] != null) {
        break;
      }
      _floor = p;
    }
  }

  void set(ElementPosition position, MeasureElement widget) {
    if (position > _ceil) _ceil = position;
    if (position < floor) _floor = position;
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
