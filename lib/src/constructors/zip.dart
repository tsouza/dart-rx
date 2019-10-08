library rx.operators.zip;

import 'package:rx/src/constructors/iterable.dart';
import 'package:rx/src/core/observable.dart';
import 'package:rx/src/core/scheduler.dart';
import 'package:rx/src/operators/zip.dart';
import 'package:rx/src/schedulers/immediate.dart';

extension ZipConstructor on Observable {
  /// Combines a list of [Observable] to an [Observable] whose values are
  /// calculated from the next value of each of its inputs.
  static Observable<List<T>> zip<T>(Iterable<Observable<T>> iterable,
          {Scheduler scheduler}) =>
      iterable.toObservable(scheduler: scheduler ?? ImmediateScheduler()).zip();
}
