import 'grid_world.dart';

/// GridPrinter prints a [GridWorld] to a single line string.
class GridPrinter {
  /// Returns the world's dimensions, e.g. '{3x5}'.
  String asString(GridWorld w) {
    return '{${w.nRows}x${w.nCols}}';
  }
}
