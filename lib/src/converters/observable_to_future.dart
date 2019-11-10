library rx.converters.observable_to_future;

import 'dart:async';

import '../core/errors.dart';
import '../core/observable.dart';
import '../core/observer.dart';
import '../core/subscription.dart';

extension ObservableToFuture<T> on Observable<T> {
  /// A [Future] that completes with the first value of an [Observable].
  Future<T> toFuture() {
    final subscriptions = Subscription.composite();
    final completer = Completer<T>();
    final observer = Observer<T>(
      next: (value) {
        completer.complete(value);
        subscriptions.unsubscribe();
      },
      error: (error, [stackTrace]) {
        completer.completeError(error, stackTrace);
        subscriptions.unsubscribe();
      },
      complete: () {
        completer.completeError(TooFewError());
        subscriptions.unsubscribe();
      },
    );
    subscriptions.add(observer);
    subscriptions.add(subscribe(observer));
    return completer.future;
  }
}
