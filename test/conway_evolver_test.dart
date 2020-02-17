import 'package:grid_world/grid_world.dart';
import 'package:test/test.dart';

void main() {
  final e = ConwayEvolver();

  test('a single lonely cell dies', () {
    var w = GridWorld.fromString('''
.....
.....
..#..
.....
.....
''');

    // Verify it doesn't survive one step.
    w.takeStep(e);
    expect(w.toString(), equals('''
.....
.....
.....
.....
.....
'''));

    // Verify it stays dead over 100 cycles.  Sigh.
    w.takeSteps(e, 100);
    expect(w.toString(), equals('''
.....
.....
.....
.....
.....
'''));
  });

  test('blinker', () {
    var w = ConwayEvolver.blinker;
    expect(w.toString(), equals('''
.....
..#..
..#..
..#..
.....
'''));
    w.takeStep(e);
    expect(w.toString(), equals('''
.....
.....
.###.
.....
.....
'''));

    // Period is two.
    w.takeStep(e);
    expect(w, equals(ConwayEvolver.blinker));

    // Do one more period.
    w.takeSteps(e, 2);
    expect(w, equals(ConwayEvolver.blinker));
  });

  test('pentaDecathlon', () {
    var w = ConwayEvolver.pentaDecathlon;
    expect(w.toString(), equals('''
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
'''));
    w.takeStep(e);
    expect(w.toString(), equals('''
...........
...........
.....#.....
....###....
...#.#.#...
...#.#.#...
....###....
.....#.....
...........
...........
.....#.....
....###....
...#.#.#...
...#.#.#...
....###....
.....#.....
...........
...........
'''));

    w.takeStep(e);
    expect(w.toString(), equals('''
...........
...........
....###....
...........
...#...#...
...#...#...
...........
....###....
...........
...........
....###....
...........
...#...#...
...#...#...
...........
....###....
...........
...........
'''));

    // Period is 15; already took 2 steps, take 13 more.
    w.takeSteps(e, 13);
    expect(w, equals(ConwayEvolver.pentaDecathlon));
  });

  test('lightwieghtSpaceship', () {
    var w = ConwayEvolver.lightweightSpaceship.padRight(30);
    expect(w.toString(), equals('''
.....................................
.#..#................................
.....#...............................
.#...#...............................
..####...............................
.....................................
'''));
    // Period is four.
    w.takeSteps(e, 4);
    expect(w.toString(), equals('''
.....................................
...#..#..............................
.......#.............................
...#...#.............................
....####.............................
.....................................
'''));

    w.takeSteps(e, 4);
    expect(w.toString(), equals('''
.....................................
.....#..#............................
.........#...........................
.....#...#...........................
......####...........................
.....................................
'''));

    w.takeSteps(e, 8 * 4);
    expect(w.toString(), equals('''
.....................................
.....................#..#............
.........................#...........
.....................#...#...........
......................####...........
.....................................
'''));

    // Take enough periods to fly past world boundary.
    w.takeSteps(e, 26 * 4);
    expect(w.toString(), equals('''
.....................................
..#.................................#
...#.................................
...#................................#
####.................................
.....................................
'''));
  });

  test('glider', () {
    var w = ConwayEvolver.glider.padBottom(1).padTop(1).padLeft(1).padRight(1);
    expect(w.toString(), equals('''
.........
.........
....#....
.....#...
...###...
.........
.........
'''));
    // Period is four.
    w.takeSteps(e, 4);
    expect(w.toString(), equals('''
.........
.........
.........
.....#...
......#..
....###..
.........
'''));

    w.takeSteps(e, 4);
    expect(w.toString(), equals('''
.........
.........
.........
.........
......#..
.......#.
.....###.
'''));

    // Take four periods to fly past world boundary.
    w.takeSteps(e, 4 * 4);
    expect(w.toString(), equals('''
.........
.#.......
..#......
###......
.........
.........
.........
'''));
  });

  // Show how the gun works.
  test('gliderGun', () {
    var w = ConwayEvolver.gosperGliderGun
        .padLeft(2)
        .padTop(2)
        .padBottom(46)
        .padRight(33);
    w.takeSteps(e, 200);
    expect(w.toString(), equals('''
.........................................................................
.........................................................................
.........................................................................
.............................##..........................................
............................#...#........................................
............##.............#.....#...##..................................
............##.............#...#.##..##..................................
...##...#......##..........#.....#.......................................
...#.#...#.....###..........#...#........................................
....#####......##............##..........................................
.....###....##.........#.#...............................................
............##..........##...............................................
........................#................................................
.........................................................................
.........................................................................
.........................................................................
.........................................................................
...............................#.........................................
................................##.......................................
...............................##........................................
.........................................................................
.........................................................................
.........................................................................
.........................................................................
.........................................................................
......................................#.#................................
.......................................##................................
.......................................#.................................
.........................................................................
.........................................................................
.........................................................................
.........................................................................
..............................................#..........................
...............................................##........................
..............................................##.........................
.........................................................................
.........................................................................
.........................................................................
.........................................................................
.........................................................................
.....................................................#.#.................
......................................................##.................
......................................................#..................
.........................................................................
.........................................................................
.........................................................................
.........................................................................
.............................................................#...........
..............................................................##.........
.............................................................##..........
.........................................................................
.........................................................................
.........................................................................
.........................................................................
.........................................................................
....................................................................#.#..
.....................................................................##..
.....................................................................#...
.........................................................................
'''));
  });

  // Shoot two guns at each other.
  test('gunFight', () {
    var w = ConwayEvolver.gunFight();
    w.takeSteps(e, 150);
    expect(w.toString(), equals('''
......................................................................
.........................#............................................
.......................#.#............................................
.............##......##............##.................................
............#...#....##............##.................................
.##........#.....#...##...............................................
.##........#...#.##....#.#............................................
...........#.....#.......#............................................
............#...#.....................................................
.............##.......................................................
........................#.............................................
.........................##...........................................
........................##............................................
......................................................................
......................................................................
......................................................................
......................................................................
......................................................................
................................#.....................................
......................................................................
......................................................................
......................................................................
......................................................................
.....................................#................................
......................................................................
......................................................................
......................................................................
......................................................................
......................................................................
............................................##........................
...........................................##.........................
.............................................#........................
.......................................................##.............
.....................................................#...#............
............................................#.......#.....#...........
............................................#.#....##.#...#........##.
...............................................##...#.....#........##.
.................................##............##....#...#............
.................................##............##......##.............
............................................#.#.......................
............................................#.........................
......................................................................
'''));
  });
}
