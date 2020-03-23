import 'dart:io';
import 'package:grid_world/grid_world.dart';

/// Make room on terminal for ANSI painting.
void clearScreen(GridWorld w) {
  for (var i = 0; i < w.nRows + 2; i++) {
    // ignore: avoid_print
    print('');
  }
}

/// Tuple of a step count and a world.
class Tup {
  Tup(this.numSteps, this.w);
  final int numSteps;
  final GridWorld w;
}

/// Demo various Conway Game of Life patterns.
void main() {
  final str = GridStringerAnsi();
  const pause = Duration(milliseconds: 100);

  for (final tup in [
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
    for (final w in GridWorldIterable(tup.w, limit: tup.numSteps)) {
      // ignore: avoid_print
      print(str.asString(w));
      sleep(pause);
    }
  }
}
