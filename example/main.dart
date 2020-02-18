 import 'dart:io';

import 'package:grid_world/grid_world.dart';

void movie(GridWorld w, int n) {
  // Make room on screen for ansi painting.
  for (var i = 0; i < (w.nRows + 2); i++) {
    print("");
  }
  final pr = GridStringerAnsi();
  print(pr.asString(w));
  final e = ConwayEvolver();
  for (int i = 0; i < n; i++) {
    w.takeStep(e);
    sleep(const Duration(milliseconds: 100));
    print(pr.asString(w));
  }
}

void main() {
  movie(ConwayEvolver.blinker, 30);
  movie(ConwayEvolver.toad, 40);
  movie(ConwayEvolver.rPentimino, 40);
  movie(ConwayEvolver.pentaDecathlon.clockwise90(), 45);
  movie(ConwayEvolver.lightweightSpaceship.padRight(30).padBottom(1), 80);
  movie(ConwayEvolver.glider.padRight(22).padBottom(20), 60);
  movie(ConwayEvolver.gliderFleet(), 80);
  movie(ConwayEvolver.gunFight(), 500);
}
