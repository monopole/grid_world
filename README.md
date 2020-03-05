# GridWorld

Conway's Game of Life as an API.

```
git clone git@github.com:monopole/grid_world.git
dart grid_world/example/main.dart
```

The API has three interfaces: `GridWorld`, `Evolver` and `GridStringer`.

### `GridWorld`

A `GridWorld` is a grid of cells that can be dead or alive.

A `GridWorld` can be constructed from

 * a multi-line string, e.g.
   ```dart
   blinker = GridWorld.fromString('''
   .....
   ..#..
   ..#..
   ..#..
   .....
   ''');
   ```

   where `.` means _dead_, and anything else means _alive_.

 * other worlds pasted into or appended to each other.

The cells have no builtin rules regarding their evolution.


### `Evolver`

A `GridWorld` accepts an `Evolver` to push it
through discrete evolutionary steps.

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

A `GridWorld` can be converted to a string using
a `GridStringer`.

`GridStringerAnsi` is a `GridStringer` that converts a world
to a string with embedded ANSI escape sequences for
animation on a terminal.

