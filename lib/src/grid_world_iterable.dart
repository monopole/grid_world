import 'conway_evolver.dart';
import 'evolver.dart';
import 'grid_world.dart';

/// GridWorldIterable is a [_GridWorldIterator] factory seeded with a GridWorld
/// a [ConwayEvolver], and an iteration limit so that attempts to pass the
/// iterable to, say, List.from(iterable) won't explode.
///
/// If [snapshots] is false (the default), each iteration returns a pointer to
/// the same underlying (but evolved) world.  This is fine if you show the world
/// at that moment.  It saves memory.
///
/// If snapshots is true, each iteration step will return a distinct copy
/// of the world - this is the right thing for making a List.from(iterable)
/// where one expects each element to be distinct/different.
class GridWorldIterable extends Iterable<GridWorld> {
  final GridWorld _gw;
  final int limit;
  final bool snapshots;
  GridWorldIterable(this._gw, {this.limit = 50, this.snapshots = false})
      : assert(_gw != null && limit >= 0);

  @override
  Iterator<GridWorld> get iterator =>
      _GridWorldIterator(_gw.copy(), ConwayEvolver(), limit, snapshots);
}

/// GridWorldIterator pairs a [GridWorld] with an [Evolver] for iteration.
/// It will emit only [_limit] instances of the world, then terminate.
class _GridWorldIterator extends Iterator<GridWorld> {
  int _count = 0;
  final int _limit;
  final Evolver _ev;
  final bool _snapshots;
  final GridWorld _gw;

  @override
  GridWorld get current => _snapshots ? _gw.copy() : _gw;

  _GridWorldIterator(this._gw, this._ev, this._limit, this._snapshots)
      : assert(_gw != null && _ev != null && _limit >= 0);

  @override
  bool moveNext() {
    if (_count == _limit) {
      return false;
    }
    _count++;
    if (_count > 1) {
      // Don't take a step until the initial world was seen.
      _gw.takeStep(_ev);
    }
    return true;
  }
}
