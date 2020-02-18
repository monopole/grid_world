# Grid World

A dart implementation of Conway's Game of Life.

`GridWorld` is an _NxM_ grid of cells that can be dead or alive.

A `GridWorld` can be constructed from
 * a multi-line string, e.g.
   ```
   .....
   ..#..
   ..#..
   ..#..
   .....
   ```
   where `.` means _dead_, and anything else means _alive_.
 * other worlds pasted into or appended to each other.

A `GridWorld` accepts an `Evolver` to evolve it
forward in time.
A `ConwayEvolver` is an `Evolver` embodying Conway's
_game of life_ rules.

This evolver defines some small worlds
containing famous GOL patterns,
e.g. the _Gosper glider gun_:

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

These small worlds can be rotated, flipped and combined to build larger worlds
using `GridWorld` methods.

A world can be converted to various strings using `GridStringer` helper classes.

The `GridStringerAnsi` class converts a world to a string with
embedded ANSI escape sequences that can be used to create
an animation on a terminal.

Demo:

```
git clone git@github.com:monopole/grid_world.git
dart grid_world/example/main.dart
```
