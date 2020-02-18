import 'grid_world.dart';

/// Evolver controls a [GridWorld]'s cell lifecycle.
class Evolver {
  /// Returns true if the cell at {i,j} lives to the next generation.
  bool aliveAtNextStep(GridWorld w, int i, int j) => true;
}
