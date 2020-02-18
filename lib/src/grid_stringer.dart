import 'grid_world.dart';

/// GridStringer converts a [GridWorld] to a single line summary string.
class GridStringer {
  /// Returns the world's dimensions, e.g. '{3x5}'.
  String asString(GridWorld w) {
    return '{${w.nRows}x${w.nCols}}';
  }
}
