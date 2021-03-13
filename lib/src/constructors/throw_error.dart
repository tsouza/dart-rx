import '../core/observable.dart';
import '../core/observer.dart';
import '../disposables/disposable.dart';
import '../schedulers/immediate.dart';
import '../schedulers/scheduler.dart';

/// An [Observable] that emits no items and immediately throws an error.
Observable<T> throwError<T>(Object error,
        {StackTrace? stackTrace, Scheduler? scheduler}) =>
    ThrowErrorObservable<T>(error, stackTrace ?? StackTrace.current,
        scheduler ?? const ImmediateScheduler());

class ThrowErrorObservable<T> with Observable<T> {
  final Object error;
  final StackTrace stackTrace;
  final Scheduler scheduler;

  const ThrowErrorObservable(this.error, this.stackTrace, this.scheduler);

  @override
  Disposable subscribe(Observer observer) =>
      scheduler.schedule(() => observer.error(error, stackTrace));
}
