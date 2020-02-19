import 'package:grid_world/grid_world.dart';

/// Make room on terminal for ANSI painting.
void clearScreen(GridWorld w) {
  for (var i = 0; i < (w.nRows + 2); i++) {
    print("");
  }
}

/// Tuple of a step count and a world.
class Tup {
  final int numSteps;
  final GridWorld w;
  Tup(int n, GridWorld w)
      : numSteps = n,
        w = w;
}

/// Demo various Conway Game of Life patterns.
void main() {
  final str = GridStringerAnsi();
  final ev = ConwayEvolver();
  const pause = Duration(milliseconds: 100);

  for (Tup tup in [
    Tup(30, ConwayEvolver.blinker),
    Tup(40, ConwayEvolver.toad),
    Tup(45, ConwayEvolver.pentaDecathlon.clockwise90()),
    Tup(60, ConwayEvolver.lightweightSpaceship.padRight(30).padBottom(1)),
    Tup(60, ConwayEvolver.glider.padRight(22).padBottom(20)),
    Tup(80, ConwayEvolver.gliderFleet()),
    Tup(100, ConwayEvolver.gunFight()),
    Tup(1000, ConwayEvolver.rPentimino.padded(30)),
  ]) {
    clearScreen(tup.w);
    tup.w.movie(tup.numSteps, str, ev, pause);
  }
}
