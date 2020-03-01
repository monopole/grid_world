import 'dart:math';
import 'dart:io';

import 'grid_stringer.dart';
import 'grid_stringer_plain.dart';
import 'evolver.dart';

/// A grid of dead or alive cells that accepts an [Evolver].
class GridWorld {
  /// Constructor accepting a pre-defined cell list.
  /// Fails if the world isn't rectangular.
  GridWorld(int numRows, List<bool> cells)
      : _numRows = numRows,
        _numCols = cells.length ~/ numRows,
        _cells = cells,
        assert(cells.length == (numRows * (cells.length ~/ numRows)));

  /// fromString initializes a world from a multi-line string.
  ///
  /// The string argument should be a multi-line string like
  ///
  /// ```
  /// '''
  /// ...#...
  /// ..#.#..
  /// .#.#.#.
  /// ...#...
  /// ...#...
  /// ...#...
  /// '''
  /// ```
  ///
  /// The shape must be rectangular (not necessarily square).
  ///
  /// Cells are initialized per the rules
  ///
  ///   - `'.'`: dead
  ///   - anything else: alive
  ///
  factory GridWorld.fromString(String x) {
    final rawLines = x.split('\n');
    var lines = List<List<int>>();
    rawLines.forEach((line) {
      if (line.isNotEmpty) {
        lines.add(line.codeUnits);
      }
    });
    if (lines.length < 2) {
      throw 'must supply at least two lines';
    }
    final nR = lines.length;
    final nC = lines[0].length;
    for (int i = 1; i < lines.length; i++) {
      if (lines[i].length != nC) {
        throw 'length (${lines[i].length}) of line $i must ' +
            'match length ($nC) of first line';
      }
    }
    final list = List<bool>(nR * nC);
    int k = 0;
    lines.forEach((line) {
      line.forEach((ch) {
        list[k] = (ch != GridWorld.chDead);
        k++;
      });
    });
    return GridWorld(nR, list);
  }

  /// Return an nR x nC world with all cells dead.
  factory GridWorld.empty(int nR, int nC) =>
      GridWorld(nR, List<bool>.filled(nR * nC, false));

  /// Return a square world (side length n) with diagonal elements alive.
  factory GridWorld.identity(int n) {
    final w = GridWorld.empty(n, n);
    for (int i = 0; i < n; i++) {
      w._cells[w.index(i, i)] = true;
    }
    return w;
  }

  // The world has fixed dimensions.
  final int _numRows;
  final int _numCols;

  // A true entry is alive, a false entry is not alive.
  final List<bool> _cells;

  /// Number of rows in the world.
  int get nRows => _numRows;

  /// Number of columns in the world.
  int get nCols => _numCols;

  @override
  bool operator ==(o) {
    if (identical(this, o)) {
      return true;
    }
    return o is GridWorld && nRows == o.nRows && _cellsEqual(o._cells);
  }

  bool _cellsEqual(final List<bool> o) {
    if (_cells.length != o.length) {
      return false;
    }
    for (int i = 0; i < _cells.length; i++) {
      if (_cells[i] != o[i]) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode => nRows.hashCode + _cellsHashCode();

  int _cellsHashCode() {
    int h = 0;
    for (int i = 0; i < _cells.length; i++) {
      h = 31 * h + (_cells[i] ? 1231 : 1237);
    }
    return h;
  }

  /// Return an index into cells using {row,column} notation.
  int index(int i, int j) => (i * _numCols) + j;

  /// Is the cell at {i,j} alive right now?
  bool isAlive(int i, int j) => _cells[index(i, j)];

  /// Is the cell at the mapped {i,j} location alive right now?
  bool customIsAlive(int Function(int, int) f, int i, int j) => _cells[f(i, j)];

  /// Return the world as a String using the given printer.
  String asString(GridStringer p) => p.asString(this);

  static final GridStringer _defaultPrinter = GridStringerPlain();

  /// Return the world as a string using a builtin printer.
  @override
  String toString() => asString(_defaultPrinter);

  /// Character representing a dead cell.
  static final chDead = ".".codeUnitAt(0);

  /// Character representing a live cell.
  static final chAlive = "#".codeUnitAt(0);

  /// Copy this.
  GridWorld copy() => GridWorld(_numRows, List<bool>.from(_cells));

  /// Copy this as a transpose.
  GridWorld transpose() {
    final newCells = List<bool>(_numRows * _numCols);
    final newIndex = (int j, int i) => (j * _numRows) + i;
    for (int i = 0; i < _numRows; i++) {
      for (int j = 0; j < _numCols; j++) {
        newCells[newIndex(j, i)] = isAlive(i, j);
      }
    }
    return GridWorld(_numCols, newCells);
  }

  /// Copy this as a clockwise 90 degree rotation.
  GridWorld clockwise90() {
    final newCells = List<bool>(_numRows * _numCols);
    final newIndex = (int i, int j) => (j * _numRows) + (_numRows - 1 - i);
    for (int i = 0; i < _numRows; i++) {
      for (int j = 0; j < _numCols; j++) {
        newCells[newIndex(i, j)] = isAlive(i, j);
      }
    }
    return GridWorld(_numCols, newCells);
  }

  /// Copy this as a counter-clockwise 90 degree rotation.
  GridWorld counterClockwise90() {
    final newCells = List<bool>(_numRows * _numCols);
    final newIndex = (int i, int j) => ((_numCols - 1 - j) * _numRows) + i;
    for (int i = 0; i < _numRows; i++) {
      for (int j = 0; j < _numCols; j++) {
        newCells[newIndex(i, j)] = isAlive(i, j);
      }
    }
    return GridWorld(_numCols, newCells);
  }

  /// Paste the other world into this one.
  ///
  /// The other world's {0,0} ends up at this world's {cI,cJ}.
  /// This world won't grow to fit.  If other world is too big or too far
  /// 'down' or 'right' it will overwrite cells due to boundary wrapping.
  void _paste(final int cI, final int cJ, final GridWorld other) {
    for (int i = 0; i < other.nRows; i++) {
      final int tI = (cI + i) % _numRows;
      for (int j = 0; j < other.nCols; j++) {
        _cells[index(tI, (cJ + j) % _numCols)] = other.isAlive(i, j);
      }
    }
  }

  /// Copy this with the other world pasted in at the given location.
  ///
  /// Result will be large enough to contain both.
  GridWorld paste(final int cI, final int cJ, final GridWorld other) =>
      GridWorld.empty(
          max(_numRows, cI + other.nRows), max(_numCols, cJ + other.nCols))
        .._paste(0, 0, this)
        .._paste(cI, cJ, other);

  /// Copy this, adding padding all around.
  GridWorld padded(int n) =>
      GridWorld.empty(_numRows + (2 * n), _numCols + (2 * n))
        .._paste(n, n, this);

  /// Copy this, adding padding on sides.
  GridWorld lrPadded(int n) =>
      GridWorld.empty(_numRows, _numCols + (2 * n)).._paste(0, n, this);

  /// Copy this, adding padding on top and bottom.
  GridWorld tbPadded(int n) =>
      GridWorld.empty(_numRows + (2 * n), _numCols).._paste(n, 0, this);

  /// Copy this, adding padding on left.
  GridWorld padLeft(int n) =>
      GridWorld.empty(_numRows, _numCols + n).._paste(0, n, this);

  /// Copy this, adding padding on right.
  GridWorld padRight(int n) =>
      GridWorld.empty(_numRows, _numCols + n).._paste(0, 0, this);

  /// Copy this, adding padding on top.
  GridWorld padTop(int n) =>
      GridWorld.empty(_numRows + n, _numCols).._paste(n, 0, this);

  /// Copy this, adding padding on bottom.
  GridWorld padBottom(int n) =>
      GridWorld.empty(_numRows + n, _numCols).._paste(0, 0, this);

  /// Append the other world to the right of this one.
  ///
  /// Fill empty lines as needed on the bottom of the
  /// shorter of the two.
  /// No attempt to center the shorter one.
  GridWorld appendRight(GridWorld other) => paste(0, _numCols, other);

  /// Append the other world to the bottom of this one.
  ///
  /// Fill empty columns as needed on the right of the
  /// thinner of the two.
  /// No attempt to center the thinner one.
  GridWorld appendBottom(GridWorld other) => paste(_numRows, 0, other);

  /// Take N life steps.
  void takeSteps(Evolver e, int n) {
    for (int i = 0; i < n; i++) {
      takeStep(e);
    }
  }

  /// Take one step in the life of the world.
  void takeStep(Evolver e) {
    final List<bool> newCells = List<bool>(nRows * nCols);
    for (var i = 0; i < nRows; i++) {
      for (var j = 0; j < nCols; j++) {
        newCells[index(i, j)] = e.aliveAtNextStep(this, i, j);
      }
    }
    _cells.setAll(0, newCells);
  }

  /// Print a movie to the terminal.
  void movie(int numSteps, GridStringer stringer, Evolver ev, Duration pause) {
    print(stringer.asString(this));
    for (int i = 0; i < numSteps; i++) {
      takeStep(ev);
      sleep(pause);
      print(stringer.asString(this));
    }
  }
}
