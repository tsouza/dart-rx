library rx.operators.combine_latest;

import '../core/observable.dart';
import '../core/observer.dart';
import '../core/subscriber.dart';
import '../core/subscription.dart';
import '../observers/inner.dart';

extension CombineLatestOperator<T> on Observable<Observable<T>> {
  /// Combines multiple Observables to create an Observable whose values are
  /// calculated from the latest values of each of its input Observables.
  Observable<List<T>> combineLatest() => CombineLatestObservable<T>(this);
}

class CombineLatestObservable<T> extends Observable<List<T>> {
  final Observable<Observable<T>> delegate;

  CombineLatestObservable(this.delegate);

  @override
  Subscription subscribe(Observer<List<T>> observer) {
    final subscriber = CombineLatestSubscriber<T>(observer);
    subscriber.add(delegate.subscribe(subscriber));
    return subscriber;
  }
}

class CombineLatestSubscriber<T> extends Subscriber<Observable<T>>
    implements InnerEvents<T, int> {
  final List<Observable<T>> observables = [];
  final List<bool> hasValues = [];
  final List<T> values = [];

  int active;
  int pending;

  CombineLatestSubscriber(Observer<List<T>> destination) : super(destination);

  @override
  void onNext(Observable<T> value) {
    observables.add(value);
    hasValues.add(false);
    values.add(null);
  }

  @override
  void onComplete() {
    if (values.isEmpty) {
      doComplete();
    } else {
      active = observables.length;
      pending = observables.length;
      for (var i = 0; i < observables.length; i++) {
        add(InnerObserver(observables[i], this, i));
      }
    }
  }

  @override
  void notifyNext(Subscription subscription, int index, T value) {
    values[index] = value;
    if (!hasValues[index]) {
      pending--;
      hasValues[index] = true;
    }
    if (pending == 0) {
      doNext(List<T>.of(values, growable: false));
    }
  }

  @override
  void notifyError(Subscription subscription, int index, Object error,
      [StackTrace stackTrace]) {
    doError(error, stackTrace);
  }

  @override
  void notifyComplete(Subscription subscription, int index) {
    active--;
    if (active == 0) {
      doComplete();
    }
  }
}
