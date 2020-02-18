import 'grid_world.dart';
import 'grid_stringer.dart';

/// GridStringerPlain converts a [GridWorld] to a multi-line string.
class GridStringerPlain extends GridStringer {
  /// Returns the [GridWorld] as a string with nRows lines and nCols columns.
  @override
  String asString(GridWorld w) {
    var lines = StringBuffer();
    for (var i = 0; i < w.nRows; i++) {
      var sb = StringBuffer();
      for (var j = 0; j < w.nCols; j++) {
        sb.writeCharCode(
            w.isAlive(i, j) ? GridWorld.chAlive : GridWorld.chDead);
      }
      lines.writeln(sb);
    }
    return lines.toString();
  }
}
