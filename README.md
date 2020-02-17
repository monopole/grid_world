# Grid World

A dart implementation of Conway's game of life.

The `GridWorld` class has a generic NxM array
of cells that can be alive or dead.  It accepts
a function to evolve it forward one step in time.

`ConwayEvolver` is a function embodying Conway's
_game of life_ rules suitable for injection
into a `GridWorld`.

`ConwayEvolver` also defines some famous Conway GOL
patterns as easy to edit multi-line strings.
E.g. here's Gosper's glider gun:

```
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
