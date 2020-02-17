import 'grid_world.dart';
import 'grid_printer.dart';

// GridPrinterAnsi prints a GridWorld to a multi-line string
// using ANSI terminal control sequences to paint.
//
// See: https://en.wikipedia.org/wiki/ANSI_escape_code#Unix-like_systems
//
class GridPrinterAnsi extends GridPrinter {
  static const _csi = "\x1B[";
  static const _csiClear = _csi + "2J";
  static const _csiReset = _csi + "00m";
  static const _csiBlackBackground = _csi + "40m";
  static const _csiCyanBackground = _csi + "46m";

  static const _fancyAlive = _csiCyanBackground + " " + _csiReset;
  static const _fancyDead = _csiBlackBackground + " " + _csiReset;

  @override
  String asString(GridWorld w) {
    // Move cursor up.
    print(_csi + '${w.nRows+2}A');
    var lines = StringBuffer();
    for (var i = 0; i < w.nRows; i++) {
      var sb = StringBuffer();
      for (var j = 0; j < w.nCols; j++) {
        sb.write(w.isAlive(i, j) ? _fancyAlive : _fancyDead);
      }
      lines.writeln(sb);
    }
    lines.write(_csiReset);
    return lines.toString();
  }
}
