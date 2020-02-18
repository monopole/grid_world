# Grid World

A dart implementation of Conway's game of life.

`GridWorld` is an _NxM_ array of cells that can be alive or dead.
It accepts an `Evolver` to evolve it forward one step in time.

The `ConwayEvolver` is an `Evolver` embodying Conway's
_game of life_ rules.

The `ConwayEvolver` also defines static strings representing
famous Conway GOL patterns as multi-line strings,
e.g. the Gosper glider gun:

```dart
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
```

Worlds can be built by sending these patterns
into `GridWorld` composition methods.

Printers are provided that convert a `GridWorld`
to a printable string, including strings
that include ANSI escape sequences to animate
the world on terminals.

Demo:

```
git clone git@github.com:monopole/grid_world.git
dart grid_world/example/main.dart
```
