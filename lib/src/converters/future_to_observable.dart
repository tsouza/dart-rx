library rx.converters.future_to_observable;

import 'dart:async';

import '../core/observable.dart';
import '../core/observer.dart';
import '../disposables/disposable.dart';
import '../disposables/stateful.dart';

extension FutureToObservable<T> on Future<T> {
  /// An [Observable] that listens to the completion of a [Future].
  Observable<T> toObservable() => FutureObservable<T>(this);
}

class FutureObservable<T> with Observable<T> {
  final Future<T> future;

  const FutureObservable(this.future);

  @override
  Disposable subscribe(Observer<T> observer) =>
      FutureDisposable(future, observer);
}

class FutureDisposable<T> extends StatefulDisposable {
  final Future<T> future;
  final Observer<T> observer;

  FutureDisposable(this.future, this.observer) {
    future.then(onValue, onError: onError);
  }

  void onValue(T value) {
    if (isDisposed) {
      return;
    }
    observer.next(value);
    observer.complete();
  }

  void onError(Object error, StackTrace stackTrace) {
    if (isDisposed) {
      return;
    }
    observer.error(error, stackTrace);
  }
}
