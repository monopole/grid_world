# GridWorld

[GridWorld] is a cellular automaton library associated with a rectangular grid.

It includes Conway's Game of Life evolution rules, and some classic
Conway patterns ready for injection.

```bash
git clone git@github.com:monopole/grid_world.git
cd grid_world
pub run test
dart example/main.dart
```

## Primary interfaces
 
### `GridWorld`

A `GridWorld` is a grid of cells that can be dead or alive.

A `GridWorld` can be constructed from

 * a multi-line string, e.g.
   ```dart
   final blinker = GridWorld.fromString('''
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
For that, see `Evolver`.


### `Evolver`

A `GridWorld` accepts, via its `takeStep` method,
an `Evolver`.

An `Evolver` pushes a world forward in time
per some set of evolutionary rules.

A `ConwayEvolver` is an `Evolver` embodying Conway's
GOL rules with wrap-around boundary conditions.
This evolver also defines some static instances of
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

[GridWorld]: https://pub.dev/packages/grid_world
