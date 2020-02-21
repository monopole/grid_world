import 'dart:math';
import 'dart:io';

import 'grid_stringer.dart';
import 'grid_stringer_plain.dart';
import 'evolver.dart';

/// A grid of dead or alive cells that accepts an [Evolver].
class GridWorld {
  // The world has fixed dimensions.
  final int _numRows;
  final int _numCols;

  // A true entry is alive, a false entry is not alive.
  final List<bool> _cells;

  /// Number of rows in the world.
  int get nRows => _numRows;

  /// Number of columns in the world.
  int get nCols => _numCols;

  /// Constructor accepting a pre-defined cell list.
  /// Fails if the world isn't rectangular.
  GridWorld(int numRows, List<bool> cells)
      : _numRows = numRows,
        _numCols = cells.length ~/ numRows,
        _cells = cells,
        assert(cells.length == (numRows * (cells.length ~/ numRows)));

  /// Return an index into cells using {row,column} notation.
  int index(int i, int j) => (i * _numCols) + j;

  /// Is the cell at {i,j} alive right now?
  bool isAlive(int i, int j) => _cells[index(i, j)];

  /// Is the cell at the mapped {i,j} location alive right now?
  bool customIsAlive(int Function(int, int) f, int i, int j) => _cells[f(i, j)];

  /// Return the world as a String using the given printer.
  String asString(GridStringer p) {
    return p.asString(this);
  }

  static final GridStringer _defaultPrinter = GridStringerPlain();

  /// Return the world as a string using a builtin printer.
  @override
  String toString() {
    return asString(_defaultPrinter);
  }

  /// Character representing a dead cell.
  static final chDead = ".".codeUnitAt(0);

  /// Character representing a live cell.
  static final chAlive = "#".codeUnitAt(0);

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
  ///   - '.': _dead_
  ///   - anything else: _alive_
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
  factory GridWorld.empty(int nR, int nC) {
    return GridWorld(nR, List<bool>.filled(nR * nC, false));
  }

  /// Return a square world (side length n) with diagonal elements alive.
  factory GridWorld.identity(int n) {
    final w = GridWorld.empty(n, n);
    for (int i = 0; i < n; i++) {
      w._cells[w.index(i, i)] = true;
    }
    return w;
  }

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
  GridWorld paste(final int cI, final int cJ, final GridWorld other) {
    var w = GridWorld.empty(
        max(_numRows, cI + other.nRows), max(_numCols, cJ + other.nCols));
    w._paste(0, 0, this);
    w._paste(cI, cJ, other);
    return w;
  }

  /// Copy this, adding padding all around.
  GridWorld padded(int n) {
    var w = GridWorld.empty(_numRows + (2 * n), _numCols + (2 * n));
    w._paste(n, n, this);
    return w;
  }

  /// Copy this, adding padding on left.
  GridWorld padLeft(int n) {
    var w = GridWorld.empty(_numRows, _numCols + n);
    w._paste(0, n, this);
    return w;
  }

  /// Copy this, adding padding on right.
  GridWorld padRight(int n) {
    var w = GridWorld.empty(_numRows, _numCols + n);
    w._paste(0, 0, this);
    return w;
  }

  /// Copy this, adding padding on top.
  GridWorld padTop(int n) {
    var w = GridWorld.empty(_numRows + n, _numCols);
    w._paste(n, 0, this);
    return w;
  }

  /// Copy this, adding padding on bottom.
  GridWorld padBottom(int n) {
    var w = GridWorld.empty(_numRows + n, _numCols);
    w._paste(0, 0, this);
    return w;
  }

  /// Append the other world to the right of this one.
  ///
  /// Fill empty lines as needed on the bottom of the
  /// shorter of the two.
  /// No attempt to center the shorter one.
  GridWorld appendRight(GridWorld other) {
    return paste(0, _numCols, other);
  }

  /// Append the other world to the bottom of this one.
  ///
  /// Fill empty columns as needed on the right of the
  /// thinner of the two.
  /// No attempt to center the thinner one.
  GridWorld appendBottom(GridWorld other) {
    return paste(_numRows, 0, other);
  }

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
