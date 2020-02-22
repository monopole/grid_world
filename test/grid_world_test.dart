import 'package:grid_world/grid_world.dart';
import 'package:test/test.dart';

void main() {
  final _halfArrow = GridWorld.fromString('''
..#..
..##.
..###
..#..
..#..
..#..
''');

  test('construction from string', () {
    expect(_halfArrow.toString(), equals('''
..#..
..##.
..###
..#..
..#..
..#..
'''));
  });

  final _identity06 = GridWorld.identity(6);
  final _identity12 = GridWorld.identity(12);

  test('equals', () {
    final other = GridWorld.identity(6);
    expect(_identity06, isNot(same(other)));
    expect(_identity06, equals(other));
    expect(_identity06, isNot(equals(other.clockwise90())));
  });

  test('hashCode', () {
    final other = GridWorld.identity(6);
    expect(_identity06.hashCode, equals(other.hashCode));
    expect(_identity06, isNot(equals(other.clockwise90().hashCode)));
  });

  test('identity', () {
    expect(_identity06.toString(), equals('''
#.....
.#....
..#...
...#..
....#.
.....#
'''));
  });

  test('paste', () {
    var w = _identity12.paste(0, 0, _halfArrow);
    expect(w.toString(), equals('''
..#.........
..##........
..###.......
..#.........
..#.........
..#..#......
......#.....
.......#....
........#...
.........#..
..........#.
...........#
'''));
    w = _identity12.paste(0, 3, _halfArrow);
    expect(w.toString(), equals('''
#....#......
.#...##.....
..#..###....
.....#......
.....#......
.....#......
......#.....
.......#....
........#...
.........#..
..........#.
...........#
'''));
    w = _identity12.paste(4, 4, _halfArrow);
    expect(w.toString(), equals('''
#...........
.#..........
..#.........
...#........
......#.....
......##....
......###...
......#.....
......#.....
......#..#..
..........#.
...........#
'''));
    w = _identity12.paste(12, 12, _halfArrow);
    expect(w.toString(), equals('''
#................
.#...............
..#..............
...#.............
....#............
.....#...........
......#..........
.......#.........
........#........
.........#.......
..........#......
...........#.....
..............#..
..............##.
..............###
..............#..
..............#..
..............#..
'''));
  });

  test('counterClockwise90', () {
    var w = _halfArrow.counterClockwise90();
    expect(w.toString(), equals('''
..#...
.##...
######
......
......
'''));
    expect(
        w
            .counterClockwise90()
            .counterClockwise90()
            .counterClockwise90()
            .toString(),
        equals(_halfArrow.toString()));
  });

  test('clockwise90', () {
    var w = _halfArrow.clockwise90();
    expect(w.toString(), equals('''
......
......
######
...##.
...#..
'''));
    expect(w.clockwise90().clockwise90().clockwise90().toString(),
        equals(_halfArrow.toString()));
  });

  test('transpose', () {
    var w = _halfArrow.transpose();
    expect(w.toString(), equals('''
......
......
######
.##...
..#...
'''));
    expect(_identity12.transpose().toString(), equals(_identity12.toString()));
    w = GridWorld.fromString('''
...#...
..#.#..
.#.#.#.
...#...
...#...
...#...
''').transpose();
    expect(w.toString(), equals('''
......
..#...
.#....
#.####
.#....
..#...
......
'''));
  });

  test('leftPadded', () {
    var w = _halfArrow.padLeft(2);
    expect(w.toString(), equals('''
....#..
....##.
....###
....#..
....#..
....#..
'''));
  });

  test('rightPadded', () {
    var w = _halfArrow.padRight(2);
    expect(w.toString(), equals('''
..#....
..##...
..###..
..#....
..#....
..#....
'''));
  });

  test('topPadded', () {
    var w = _halfArrow.padTop(2);
    expect(w.toString(), equals('''
.....
.....
..#..
..##.
..###
..#..
..#..
..#..
'''));
  });

  test('bottomPadded', () {
    var w = _halfArrow.padBottom(2);
    expect(w.toString(), equals('''
..#..
..##.
..###
..#..
..#..
..#..
.....
.....
'''));
  });

  test('padded', () {
    var w = _halfArrow.padded(3);
    expect(w.toString(), equals('''
...........
...........
...........
.....#.....
.....##....
.....###...
.....#.....
.....#.....
.....#.....
...........
...........
...........
'''));
  });

  test('append', () {
    var w = _halfArrow;
    w = w.appendRight(w).appendRight(w).appendRight(w);
    expect(w.toString(), equals('''
..#....#....#....#..
..##...##...##...##.
..###..###..###..###
..#....#....#....#..
..#....#....#....#..
..#....#....#....#..
'''));
    expect(w.appendBottom(w).toString(), equals('''
..#....#....#....#..
..##...##...##...##.
..###..###..###..###
..#....#....#....#..
..#....#....#....#..
..#....#....#....#..
..#....#....#....#..
..##...##...##...##.
..###..###..###..###
..#....#....#....#..
..#....#....#....#..
..#....#....#....#..
'''));
  });

  test('irregularAppendRight', () {
    var w = _halfArrow;
    w = w.appendRight(w.padTop(3));
    expect(w.toString(), equals('''
..#.......
..##......
..###.....
..#....#..
..#....##.
..#....###
.......#..
.......#..
.......#..
'''));
  });

  test('irregularAppendBottom', () {
    var w = _halfArrow;
    w = w.appendRight(w).appendRight(w);
    w = w.appendBottom(w.padLeft(3));
    expect(w.toString(), equals('''
..#....#....#.....
..##...##...##....
..###..###..###...
..#....#....#.....
..#....#....#.....
..#....#....#.....
.....#....#....#..
.....##...##...##.
.....###..###..###
.....#....#....#..
.....#....#....#..
.....#....#....#..
'''));
  });

  test('bigX', () {
    var v = _identity06.appendRight(_identity06.clockwise90());
    var x = v.appendBottom(v.clockwise90().clockwise90());
    expect(x.toString(), equals('''
#..........#
.#........#.
..#......#..
...#....#...
....#..#....
.....##.....
.....##.....
....#..#....
...#....#...
..#......#..
.#........#.
#..........#
'''));
  });

  test('mixItUp1', () {
    var r1 = _halfArrow.padLeft(2).padTop(2).padBottom(3).padRight(10);
    var r2 = r1.clockwise90().clockwise90();
    var w = r1.appendBottom(r2);
    expect(w.toString(), equals('''
.................
.................
....#............
....##...........
....###..........
....#............
....#............
....#............
.................
.................
.................
.................
.................
.................
............#....
............#....
............#....
..........###....
...........##....
............#....
.................
.................
'''));
    expect(w.transpose().toString(), equals('''
......................
......................
......................
......................
..######..............
...##.................
....#.................
......................
......................
......................
.................#....
.................##...
..............######..
......................
......................
......................
......................
'''));
  });

  test('mixItUp2', () {
    var w = _halfArrow.padRight(2);
    var w1 = w.appendRight(w.clockwise90());
    var w2 = w.counterClockwise90().appendRight(w);
    w = w1.appendBottom(w2);
    expect(w.toString(), equals('''
..#..........
..##.........
..###..######
..#.......##.
..#.......#..
..#..........
.............
........#....
........##...
..#.....###..
.##.....#....
######..#....
........#....
.............
'''));
  });
}
