# Grid World

A dart implementation of Conway's game of life.

`GridWorld` is an _NxM_ grid of cells that can be alive or dead.
A `GridWorld` accepts an `Evolver` to evolve it forward in time.

A `GridWorld` can be constructed from
 * a multi-line string, e.g.
   ```
   .....
   ..#..
   ..#..
   ..#..
   .....
   ```
 * other GridWorlds, pasted into or appended to each other.

A `ConwayEvolver` is an `Evolver` embodying Conway's
_game of life_ rules.

The `ConwayEvolver` also defines some small worlds
containing famous Conway GOL patterns, e.g. the Gosper glider gun:

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

Printers are provided that print `GridWorld`s
into strings, including strings containing
ANSI escape sequences that animate
the world on terminals.

Demo:

```
git clone git@github.com:monopole/grid_world.git
dart grid_world/example/main.dart
```
