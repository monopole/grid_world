import 'grid_world.dart';

/// GridPrinter prints a [GridWorld] to a single line string.
/// Returns something like '{3x5}'.
class GridPrinter {
  String asString(GridWorld w) {
    return '{${w.nRows}x${w.nCols}}';
  }
}
