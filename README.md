# Grid World

A dart implementation of Conway's game of life.

The GridWorld class has a generic NxM array
of cells that can be alive or dead.  It accepts
a function to evolve it forward one step in time.

ConwayEvolver is a function embodying Conway's
"game of life" rules suitable for injection
into GridWorld.

It also defines some famous patterns - heavyweight
spaceship, Gosper's glider gun, etc. as easy to
read multi-line strings.

These patterns can be injected into a world as
initial conditions or at any point in its lifecycle.

Printers are provided that print the world to
a string, which in turn can be printed to stdout.

Terminal demo:

```
git clone blah/blah/grid_world
dart grid_world/example/main.dart
```
