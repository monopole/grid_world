# GridWorld

A cellular automaton library associated with a square grid.  Includes Conway's Game of Life.

#### Demo
```
git clone git@github.com:monopole/grid_world.git
dart grid_world/example/main.dart
```

The primary interfaces are as follows:

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

### `GridWorldIterable`

Extending `Iterable<GridWorld>`, this object combines a `GridWorld` and
an `Evolver` such that one may evolve a world in an iteration context, e.g.

```dart
for (var w in GridWorldIterable(initialWorld, limit: 1000)) {
  render(w);
}
```

### `GridStringer`

A `GridWorld` can be converted to a string using
a `GridStringer`.

`GridStringerAnsi` is a `GridStringer` that converts a world
to a string with embedded ANSI escape sequences for
animation on a terminal.

