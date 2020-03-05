# GridWorld

A [dart](https://dart.dev) library for playing with
Conway's Game of Life at the command line.

```
git clone git@github.com:monopole/grid_world.git
dart grid_world/example/main.dart
```

The API has three interfaces: `GridWorld`, `Evolver` and `GridStringer`.

### `GridWorld`

A `GridWorld` is a grid of cells that can be dead or alive.

It has no inherent rules regarding evolution; it accepts
an [`Evolver`](#evolver) to mutate it through discrete steps.

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

### `Evolver`

A `GridWorld` accepts an `Evolver` to evolve it
forward in time.

A `ConwayEvolver` is an `Evolver` embodying Conway's
GOL rules with wrap-around boundary conditions.

This evolver defines some static instances of
small `GridWorlds` containing famous Conway GOL
patterns, e.g. the _Gosper glider gun_:

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

### `GridStringer`

A world can be converted to a string using
a `GridStringer`.

`GridStringerAnsi` is a `GridStringer` that converts a world
to a string with embedded ANSI escape sequences for
animation on a terminal.

