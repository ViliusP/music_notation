import 'package:collection/collection.dart';

import 'package:music_notation/src/models/elements/score/part.dart';

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

/// Represents the structure of a musical score for the purpose of rendering it
/// in a visual format.
///
/// This class takes a more complex approach to representation by using a two-dimensional
/// grid (`data`). Each row in this grid represents a part or a staff within a part
/// from a musical score, and each column corresponds to a measure.
///
/// Additionally, this class supports the concept of 'common staves', which are
/// groups of staves that are linked across multiple parts. These common staves are
/// stored as a list of lists (`commonStaves`), with each inner list corresponding
/// to a group of common staves. They can also be accessed as a map (`commonStavesMap`)
/// for easier lookup.
///
/// The grid structure provided by this class allows for efficient access to the
/// musical data, making it an effective choice for operations such as rendering the
/// score or performing musical analysis.
class RawMeasureGrid {
  /// Represents the musical score as a grid. Each row corresponds to a part or
  /// a staff within a part, and each column represents a measure.
  final Grid<Measure> data;

  /// Represents the musical score as a grid. Each row corresponds to a part or
  /// a staff within a part, and each column represents a measure.
  final List<List<int>> _commonStaves;

  /// Converts the commonStaves list into a map for easier lookup.
  /// Each key represents a row index in the grid, and its corresponding
  /// value is the list of common staves for that part.
  Map<int, List<int>> get _commonStavesMap {
    Map<int, List<int>> map = {};
    for (var list in _commonStaves) {
      for (var i in list) {
        map[i] = list;
      }
    }
    return map;
  }

  int? staffForRow(int row) {
    int? index = _commonStavesMap[row]?.indexOf(row);
    if (index == null || index == -1 || _commonStavesMap[row]?.length == 1) {
      return null;
    }
    return index + 1;
  }

  int? staffCount(int row) {
    return _commonStavesMap[row]?.length;
  }

  /// Private constructor used to initialize an instance with required properties.
  RawMeasureGrid._({
    required this.data,
    required List<List<int>> commonStaves,
  }) : _commonStaves = commonStaves;

  /// Creates a [NotationGrid] from a music notation [parts].
  ///
  /// It first calculates the number of staves in each part and adds the
  /// corresponding number of rows to the grid. Then, it iterates through the
  /// measures in each part, creating MeasureSequence instances and adding them
  /// to the corresponding row in the grid.
  factory RawMeasureGrid.fromScoreParts(List<Part> parts) {
    Grid<Measure> data = Grid();
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
      for (var measure in part.measures) {
        for (var i = 0; i < staves; i++) {
          data.addToRow(
            data.rowCount - staves + i,
            measure,
          );
        }
      }
    }
    return RawMeasureGrid._(
      data: data,
      commonStaves: commonStaves,
    );
  }
}
