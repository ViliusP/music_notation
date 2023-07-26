import 'package:collection/collection.dart';

import 'package:music_notation/src/models/data_types/step.dart';
import 'package:music_notation/src/models/elements/bookmark.dart';
import 'package:music_notation/src/models/elements/link.dart';
import 'package:music_notation/src/models/elements/listening.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/attributes.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/clef.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/key.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/time.dart';
import 'package:music_notation/src/models/elements/music_data/backup.dart';
import 'package:music_notation/src/models/elements/music_data/barline.dart';
import 'package:music_notation/src/models/elements/music_data/direction/direction.dart';
import 'package:music_notation/src/models/elements/music_data/figured_bass.dart';
import 'package:music_notation/src/models/elements/music_data/forward.dart';
import 'package:music_notation/src/models/elements/music_data/grouping.dart';
import 'package:music_notation/src/models/elements/music_data/harmony/harmony.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/models/elements/music_data/print.dart';
import 'package:music_notation/src/models/elements/music_data/sound/sound.dart';
import 'package:music_notation/src/models/elements/score/part.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/models/visual_music_element.dart';
import 'package:music_notation/src/notation_painter/models/visual_note_element.dart';

class Grid<T> extends Iterable<List<T>> {
  final List<List<T>> _grid = List<List<T>>.empty(growable: true);

  // Initialize a grid of the given size with null values
  Grid();

  @override
  Iterator<List<T>> get iterator => _RowIterator<T>(_grid);

  void addRow() {
    _grid.add(List<T>.empty(growable: true));
  }

  // Get the value at the given row and column
  T getValue(int row, int column) {
    return _grid[row][column];
  }

  // Set the value at the given row and column
  void setValue(int row, int column, T value) {
    _grid[row][column] = value;
  }

  void addColumn(List<T> values) {
    for (var (index, columnElement) in values.indexed) {
      _grid[index].add(columnElement);
    }
  }

  void addToRow(int row, T value) {
    _grid[row].add(value);
  }

  // Get the number of rows in the grid.
  int get rowCount {
    return _grid.length;
  }

  // Get the maximum number of columns in the grid.
  int get columnCount {
    return _grid.map((e) => e.length).max;
  }

  @override
  String toString() {
    final columnWidths = List<int>.filled(_grid[0].length, 0);

    for (final row in _grid) {
      for (var colIndex = 0; colIndex < row.length; colIndex++) {
        final cell = row[colIndex];
        final cellString = cell != null ? cell.toString() : '';
        columnWidths[colIndex] =
            columnWidths[colIndex].compareTo(cellString.length) < 0
                ? cellString.length
                : columnWidths[colIndex];
      }
    }

    final formattedGrid = _grid.mapIndexed((rowIndex, row) {
      final formattedRow = row.mapIndexed((colIndex, cell) {
        final cellString = cell != null ? cell.toString() : '';
        return cellString.padRight(columnWidths[colIndex]);
      }).toList();
      return formattedRow;
    }).toList();

    final tableRows = <String>[];
    for (var rowIndex = 0; rowIndex < formattedGrid.length; rowIndex++) {
      final row = formattedGrid[rowIndex];
      final rowString =
          '${rowIndex.toString().padRight(3)} | ${row.join(' | ')} |';
      tableRows.add(rowString);
    }

    final columnHeaders = Iterable<int>.generate(_grid[0].length)
        .map((colIndex) => colIndex.toString().padRight(columnWidths[colIndex]))
        .join(' | ');
    final separator = '-'.padRight(columnHeaders.length, '-');
    final table =
        [columnHeaders, separator, ...tableRows, separator].join('\n');

    return table;
  }

  // Create an unmodifiable view of the grid
  UnmodifiableGrid<T> asUnmodifiable() => UnmodifiableGrid<T>(_grid);
}

class UnmodifiableGrid<T> extends Iterable<List<T>> {
  final List<List<T>> _grid;

  UnmodifiableGrid(this._grid);

  List<T> operator [](int index) => _grid[index];

  @override
  Iterator<List<T>> get iterator => _grid.iterator;

  @override
  int get length => _grid.length;

  int numColumns(int row) => _grid[row].length;

  @override
  String toString() {
    return _grid.toString();
  }
}

class _RowIterator<T> implements Iterator<List<T>> {
  final List<List<T>> _grid;
  int _index = -1;

  _RowIterator(this._grid);

  @override
  List<T> get current {
    return _grid[_index];
  }

  @override
  bool moveNext() {
    _index++;
    return _index < _grid.length;
  }
}

class NotationGrid {
  /// Row is part or part's staff. Column is a measure.
  final Grid<MeasureGrid> data;

  // [[0], [1, 2]]
  final List<List<int>> commonStaves;

  // {0: [0], 1: [1, 2], 2: [1, 2]}
  Map<int, List<int>> get commonStavesMap {
    Map<int, List<int>> map = {};
    for (var list in commonStaves) {
      for (var i in list) {
        map[i] = list;
      }
    }
    return map;
  }

  NotationGrid._({
    required this.data,
    required this.commonStaves,
  });

  factory NotationGrid.fromScoreParts(List<Part> parts) {
    Grid<MeasureGrid> data = Grid();
    List<List<int>> commonStaves = [];
    for (var part in parts) {
      int staves = part.calculateStaves();
      commonStaves.add(List.generate(
        staves,
        (index) => data.rowCount + index,
      ));
      for (var i = 0; i < staves; i++) {
        data.addRow();
      }
      List<MeasureGrid> lastMeasures = [];
      for (var measure in part.measures) {
        for (var i = 0; i < staves; i++) {
          Clef? clef;
          if (lastMeasures.length >= i + 1) {
            clef = lastMeasures[i]._clef;
          }

          var measureGrid = MeasureGrid.fromMeasure(
            measure: measure,
            staff: staves != 1 ? i + 1 : null,
            clef: clef,
          );

          data.addToRow(
            data.rowCount - staves + i,
            measureGrid,
          );
          if (lastMeasures.length < i + 1) {
            lastMeasures.add(measureGrid);
          } else {
            lastMeasures[i] = measureGrid;
          }
        }
      }
    }
    return NotationGrid._(
      data: data,
      commonStaves: commonStaves,
    );
  }
}

class MeasureGrid extends Iterable<List<VisualMusicElement?>> {
  static const gridHeight = 84;

  static const Step startingStep = Step.G;
  static const int statingOctave = 4;

  final Grid<VisualMusicElement?> _data;
  // UnmodifiableGrid<VisualMusicElement?> get data => _data.asUnmodifiable();

  Clef? _clef;

  void setClef(Clef clef) {
    _clef = clef;
  }

  MeasureGrid._({required Grid<VisualMusicElement?> data}) : _data = data;

  // Get the value at the given row and column
  VisualMusicElement? getValue(int row, int column) {
    var data = _data.getValue(row + (gridHeight ~/ 2), column);
    if (data == null) {
      return null;
    }
    int transpose = 0;
    switch (_clef?.sign) {
      case ClefSign.F:
        transpose = 12;
        break;
      default:
    }

    if (transpose != 0 && data.influencedByClef == true) {
      return _data
          .getValue(row + (gridHeight ~/ 2), column)
          ?.tranpose(transpose);
    }
    return _data.getValue(row + (gridHeight ~/ 2), column);
  }

  // Get the value at the given row and column
  VisualMusicElement? nextNoteInColumn(int row, int column) {
    for (int i = row + 1; i < distance; i++) {
      var element = getValue(i, column);
      if (element is VisualNoteElement) {
        return element;
      }
    }
    return null;
  }

  /// Set the [value] at the given [column].
  void setElement(VisualMusicElement value, int column) {
    int row = value.position.numericPosition -
        const ElementPosition(step: Step.G, octave: 4).numericPosition;
    _data.setValue(row + (gridHeight ~/ 2), column, value);
  }

  /// Maximum available positions above and below from G4
  int get distance {
    return _data.rowCount ~/ 2;
  }

  /// Maximum elements in measure.
  int get elementCount {
    return _data.columnCount;
  }

  void addEmptyColumn() {
    final column = List<VisualMusicElement?>.filled(
      gridHeight,
      null,
    );
    _data.addColumn(column);
  }

  /// The [staff] must be provided if [measure] has multiple staves.
  factory MeasureGrid.fromMeasure({
    required Measure measure,
    int? staff,
    Clef? clef,
  }) {
    Grid<VisualMusicElement?> data = Grid();
    for (var i = 0; i < gridHeight; i++) {
      data.addRow();
    }
    MeasureGrid grid = MeasureGrid._(data: data);
    for (var musicElement in measure.data) {
      switch (musicElement) {
        case Note _:
          if (staff == musicElement.staff || staff == null) {
            if (musicElement.chord == null || grid.elementCount == 0) {
              grid.addEmptyColumn();
            }
            var noteVisual = VisualNoteElement.fromNote(musicElement);
            grid.setElement(noteVisual, grid.elementCount - 1);
          }
          break;
        case Backup _:
          break;
        case Forward _:
          break;
        case Direction _:
          break;
        case Attributes _:
          var attributeVisuals = _fromAttributes(musicElement, staff);

          for (var attributesInColumn in attributeVisuals) {
            grid.addEmptyColumn();

            for (var visual in attributesInColumn) {
              grid.setElement(visual, grid.elementCount - 1);
            }
          }

          if (musicElement.clefs.isNotEmpty) {
            if (musicElement.clefs.length > 1 && staff == null) {
              throw UnimplementedError(
                "Multiple clef signs is not implemented in renderer yet",
              );
            }
            var attributesClef = musicElement.clefs.firstWhereOrNull(
              (element) => staff != null ? element.number == staff : true,
            );
            if (attributesClef != null) {
              grid.setClef(attributesClef);
            }
          }
          break;
        case Harmony _:
          break;
        case FiguredBass _:
          break;
        case Print _:
          break;
        case Sound _:
          break;
        case Listening _:
          break;
        case Barline _:
          break;
        case Grouping _:
          break;
        case Link _:
          break;
        case Bookmark _:
          break;
      }
    }
    if (grid._clef == null && clef != null) {
      grid.setClef(clef);
    }
    return grid;
  }

  static List<List<VisualMusicElement>> _fromAttributes(
    Attributes attributes, [
    int? staff,
  ]) {
    List<List<VisualMusicElement>> visuals = [];
    if (attributes.clefs.isNotEmpty) {
      if (attributes.clefs.length > 1 && staff == null) {
        throw UnimplementedError(
          "Multiple clef signs is not implemented in renderer yet",
        );
      }
      var visual = VisualMusicElement.fromClef(attributes.clefs.firstWhere(
        (element) => staff != null ? element.number == staff : true,
      ));
      visuals.add([visual]);
    }
    for (var key in attributes.keys) {
      switch (key) {
        case TraditionalKey _:
          visuals.addAll(
            VisualKeyElement.fromTraditionalKey(key).map((e) => [e]),
          );
          break;
        case NonTraditionalKey _:
          throw UnimplementedError(
            "Non traditional key is not implemented in renderer yet",
          );
      }
    }
    for (var times in attributes.times) {
      switch (times) {
        case TimeBeat _:
          visuals.add(VisualMusicElement.fromTimeBeat(times));
          break;
        case SenzaMisura _:
          throw UnimplementedError(
            "Senza misura is not implemented in renderer yet",
          );
      }
    }
    return visuals;
  }

  @override
  String toString() {
    return _data.toString();
  }

  @override
  Iterator<List<VisualMusicElement?>> get iterator => _data.iterator;
}
