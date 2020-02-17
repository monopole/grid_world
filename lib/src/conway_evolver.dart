import 'grid_world.dart';

// Conway's Game of Life rules.
class ConwayEvolver extends Evolver {
  // Avoid passing the world to all helper methods.
  GridWorld _w;

  @override
  bool aliveAtNextStep(GridWorld w, int i, int j) {
    _w = w;
    int count = _neighborCountUpToFour(i, j);
    if (_w.isAlive(i, j)) {
      // It's alive, but will only stay alive if
      // exactly 2 or 3 neighbors are alive (i.e.,
      // the cell has some living friends, but not
      // so many that there's overpopulation).
      return count == 2 || count == 3;
    }
    // The cell is dead, but bring it to life if there
    // are exactly three neighbors.
    return count == 3;
  }

  // Returns count of the neighbors of cell {i,j},
  // stopping at four.
  // Per Conway's Game of Life rules, a count that
  // exceeds four has the same impact as a count of
  // four, so there's no reason to count past four.
  int _neighborCountUpToFour(int i, int j) {
    int count = 0;
    for (Function f in [
      _aboveLeft,
      _aboveSame,
      _aboveRight,
      _sameLeft,
      _sameRight,
      _downLeft,
      _downSame,
      _downRight,
    ]) {
      if (_w.customIsAlive(f, i, j)) {
        count++;
        if (count == 4) {
          return count;
        }
      }
    }
    return count;
  }

  // Thinking of the cell {i,j}, _aboveLeft returns the index
  // to the cell in the row above, in the column to the left.
  int _aboveLeft(int i, int j) => _w.index(_prevRow(i), _prevCol(j));

  int _aboveSame(int i, int j) => _w.index(_prevRow(i), j);

  int _aboveRight(int i, int j) => _w.index(_prevRow(i), _nextCol(j));

  int _sameLeft(int i, int j) => _w.index(i, _prevCol(j));

  // _sameSame isn't needed, but this is what it would look like:
  // int _sameSame(int i, int j) => index(i, j);

  int _sameRight(int i, int j) => _w.index(i, _nextCol(j));

  int _downLeft(int i, int j) => _w.index(_nextRow(i), _prevCol(j));

  int _downSame(int i, int j) => _w.index(_nextRow(i), j);

  int _downRight(int i, int j) => _w.index(_nextRow(i), _nextCol(j));

  // Given row i, find the previous row, wrapping around as needed.
  int _prevRow(int i) => (i + _w.nRows - 1) % _w.nRows;

  int _prevCol(int j) => (j + _w.nCols - 1) % _w.nCols;

  int _nextRow(int i) => (i + 1) % _w.nRows;

  int _nextCol(int j) => (j + 1) % _w.nCols;

  // This has a period of two.
  static final blinker = GridWorld.fromString('''
.....
..#..
..#..
..#..
.....
''');

// This has a period of fifteen.
  static final pentaDecathlon = GridWorld.fromString('''
...........
...........
...........
....###....
...#...#...
...#...#...
....###....
...........
...........
...........
...........
....###....
...#...#...
...#...#...
....###....
...........
...........
...........
''');

  // This moves to the right.
  static final lightweightSpaceship = GridWorld.fromString('''
.......
.#..#..
.....#.
.#...#.
..####.
.......
''');

  // This moves down and right.
  static final glider = GridWorld.fromString('''
.......
...#...
....#..
..###..
.......
''');

// This emits a glider every 15 iterations down and to the right.
  static final gosperGliderGun = GridWorld.fromString('''
......................................
.........................#............
.......................#.#............
.............##......##............##.
............#...#....##............##.
.##........#.....#...##...............
.##........#...#.##....#.#............
...........#.....#.......#............
............#...#.....................
.............##.......................
......................................
''');

  static final toad = GridWorld.fromString('''
......
......
..###.
.###..
......
......
''');

  static final rpentimino = GridWorld.fromString('''
.....
..##.
.##..
..#..
.....
''');

  static final indefinite = GridWorld.fromString('''
.......
.###.#.
.#.....
....##.
..##.#.
.#.#.#.
.......
''');

  static GridWorld gliderFleet() {
    final g = glider.padRight(3).padBottom(2);
    final w = g.appendRight(g).appendRight(g).appendRight(g).appendRight(g);
    return w.appendBottom(w.padLeft(3));
  }

  static GridWorld gunFight() {
    var g1 = gosperGliderGun.padBottom(10).padRight(32);
    return g1.appendBottom(g1.clockwise90().clockwise90());
  }
}
