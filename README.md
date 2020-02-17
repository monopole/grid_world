# Grid World

A dart implementation of Conway's game of life.

The `GridWorld` class has a generic NxM array
of cells that can be alive or dead.  It accepts
a function to evolve it forward one step in time.

`ConwayEvolver` is a function embodying Conway's
_game of life_ rules suitable for injection
into a `GridWorld`.

`ConwayEvolver` also defines some famous patterns -
heavyweight spaceship, Gosper's glider gun, etc. as
easy to read multi-line strings.

These patterns can be injected into a world as
initial conditions or at any time step.

Printers are provided that print the world to
a string, which in turn can be printed to stdout.

Terminal demo:

```
git clone git@github.com:monopole/grid_world.git
dart grid_world/example/main.dart
```
