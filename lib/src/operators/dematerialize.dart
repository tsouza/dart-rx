library rx.operators.dematerialize;

import '../core/errors.dart';
import '../core/events.dart';
import '../core/observable.dart';
import '../core/observer.dart';
import '../core/subscriber.dart';
import '../disposables/disposable.dart';

extension DematerializeOperator<T> on Observable<Event<T>> {
  /// Dematerialize events of this [Observable] into from a stream of [Event]
  /// subclasses [NextEvent], [ErrorEvent] or [CompleteEvent].
  Observable<T> dematerialize() => DematerializeObservable<T>(this);
}

class DematerializeObservable<T> extends Observable<T> {
  final Observable<Event<T>> delegate;

  DematerializeObservable(this.delegate);

  @override
  Disposable subscribe(Observer<T> observer) {
    final subscriber = DematerializeSubscriber<T>(observer);
    subscriber.add(delegate.subscribe(subscriber));
    return subscriber;
  }
}

class DematerializeSubscriber<T> extends Subscriber<Event<T>> {
  DematerializeSubscriber(Observer<T> observer) : super(observer);

  @override
  void onNext(Event<T> value) {
    if (value is NextEvent<T>) {
      doNext(value.value);
    } else if (value is ErrorEvent<T>) {
      doError(value.error, value.stackTrace);
    } else if (value is CompleteEvent<T>) {
      doComplete();
    } else {
      doError(UnexpectedEventError(value), StackTrace.current);
    }
  }
}
