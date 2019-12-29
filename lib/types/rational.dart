import '../types/base.dart';
import '../utils/jenkins.dart';

abstract class Rational<T extends Arithmetic<T>, U extends Rational<T, U>>
    implements Reciprocable<U> {
  final T numerator;
  final T denominator;

  const Rational(this.numerator, this.denominator);

  U Function(T, T) get constructor;

  U get reduced;

  U get reciprocal => constructor(denominator, numerator);

  bool get isOne => reduced == one;

  bool get isZero => reduced == zero;

  U operator -() => this * negative;

  U operator +(U other) => constructor(
          (this.numerator * other.denominator) +
              (this.denominator * other.numerator),
          this.denominator * other.denominator)
      .reduced;

  U operator *(U other) => constructor(this.numerator * other.numerator,
          this.denominator * other.denominator)
      .reduced;

  U operator -(U other) => this + -other;

  U operator /(U other) => this * other.reciprocal;

  int get hashCode => Jenkins.hash([numerator, denominator]);

  bool operator ==(dynamic other) =>
      other is U &&
      numerator == other.numerator &&
      denominator == other.denominator;

  String toString() =>
      '$numerator${denominator == one.denominator ? '' : ' / $denominator'}';
}
