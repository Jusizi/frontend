// ignore_for_file: non_constant_identifier_names

abstract class Either<TLeft, TRight> {
  bool get isLeft;
  bool get isRight;

  T fold<T>(T Function(TLeft l) leftFn, T Function(TRight r) rightFn);

  TRight getOrElse(TRight Function(TLeft left) orElse);

  Either<TLeft, T> bind<T>(Either<TLeft, T> Function(TRight r) fn) {
    return fold(Left, fn);
  }

  Future<Either<TLeft, T>> asyncBind<T>(
      Future<Either<TLeft, T>> Function(TRight r) fn) {
    return fold((l) async => Left(l), fn);
  }

  Either<T, TRight> leftBind<T>(Either<T, TRight> Function(TLeft l) fn) {
    return fold(fn, Right);
  }

  Either<TLeft, T> map<T>(T Function(TRight r) fn) {
    return fold(Left, (r) => Right(fn(r)));
  }

  Either<T, TRight> leftMap<T>(T Function(TLeft l) fn) {
    return fold((l) => Left(fn(l)), Right);
  }
}

class _Left<TLeft, TRight> extends Either<TLeft, TRight> {
  final TLeft _value;

  @override
  final bool isLeft = true;
  @override
  final bool isRight = false;

  _Left(this._value);

  @override
  T fold<T>(T Function(TLeft l) leftFn, T Function(TRight r) rightFn) =>
      leftFn(_value);

  @override
  TRight getOrElse(TRight Function(TLeft left) orElse) => orElse(_value);
}

class _Right<TLeft, TRight> extends Either<TLeft, TRight> {
  final TRight _value;

  _Right(this._value);

  @override
  T fold<T>(T Function(TLeft l) leftFn, T Function(TRight r) rightFn) =>
      rightFn(_value);

  @override
  TRight getOrElse(TRight Function(TLeft left) orElse) => _value;

  @override
  bool get isLeft => false;

  @override
  bool get isRight => true;
}

Either<TLeft, TRight> Right<TLeft, TRight>(TRight r) =>
    _Right<TLeft, TRight>(r);
Either<TLeft, TRight> Left<TLeft, TRight>(TLeft l) => _Left<TLeft, TRight>(l);

T id<T>(T value) => value;
