library rx.core.functions;

/// Function type used to pass a value.
typedef NextCallback<T> = void Function(T value);

/// Function type used to complete a sequence of values with a failure.
typedef ErrorCallback = void Function(Object error, [StackTrace stackTrace]);

/// Function type used to complete a sequence of values with a success.
typedef CompleteCallback = void Function();

/// Function type to map from a value of type `T` to a value of type `R`.
typedef Map0<R> = R Function();
typedef Map1<T1, R> = R Function(T1 t1);
typedef Map2<T1, T2, R> = R Function(T1 t1, T2 t2);

/// Function type for a predicate from a value of type `T`.
typedef Predicate0 = bool Function();
typedef Predicate1<T1> = bool Function(T1 t1);
typedef Predicate2<T1, T2> = bool Function(T1 t1, T2 t2);

/// The null function.
void nullFunction() {}

/// The identity function.
T identityFunction<T>(T argument) => argument;

/// The constant functions.
T Function() constantFunction0<T>(T value) => () => value;
T Function(T1) constantFunction1<T, T1>(T value) => (t1) => value;
