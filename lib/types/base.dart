abstract class Arithmetic<T extends Arithmetic<T>> {
  T operator -();

  T operator +(T other);
  T operator *(T other);

  T operator -(T other);
  T operator /(T other);
}

abstract class Countable<T extends Countable<T>> implements Arithmetic<T> {
  T get one;
  T get zero;
  T get negative;

  bool get isOne;
  bool get isZero;
}

abstract class Reciprocable<T extends Reciprocable<T>> implements Countable<T> {
  T get reciprocal;
}
