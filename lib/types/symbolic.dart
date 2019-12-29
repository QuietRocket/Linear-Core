import 'dart:collection';

import 'base.dart';
import 'rational_number.dart';
import '../utils/jenkins.dart';

class FractionMap<T> with MapMixin<T, RationalNumber> {
  final SplayTreeMap<T, RationalNumber> data;

  FractionMap() : data = SplayTreeMap();

  FractionMap.from(Map<T, RationalNumber> data)
      : data = SplayTreeMap.from(data);

  void reduce() {
    this.removeWhere((key, value) => value.isZero);
  }

  void merge(FractionMap<T> other) {
    other.forEach((key, value) {
      this.update(key, (prev) => prev + value, ifAbsent: () => value);
    });
  }

  RationalNumber operator [](Object key) => data[key];

  void operator []=(T key, RationalNumber value) {
    data[key] = value;
  }

  void clear() {
    data.clear();
  }

  Iterable<T> get keys => data.keys;

  RationalNumber remove(Object key) => data.remove(key);
}

class Variables extends FractionMap<String> implements Comparable<Variables> {
  Variables() : super();

  Variables.from(Map<String, RationalNumber> data) : super.from(data);

  Variables get reciprocal => Variables.from(this)
    ..updateAll((key, value) => value * RationalNumber.consts.negative);

  RationalNumber get degree =>
      isNotEmpty ? values.reduce((a, b) => a + b) : RationalNumber.consts.zero;

  Variables operator *(Variables other) => Variables.from(this)
    ..merge(other)
    ..reduce();

  int get hashCode => Jenkins.hash(['$this']);

  bool operator ==(dynamic other) => other is Variables && '$this' == '$other';

  int compareTo(Variables other) {
    if (this == other) {
      return 0;
    } else {
      int deltaDegree = (other.degree - degree).decimal.floor();
      int deltaVars = keys.join('').compareTo(other.keys.join(''));
      return deltaDegree == 0
          ? (deltaVars == 0 ? '$this'.compareTo('$other') : deltaVars)
          : deltaDegree;
    }
  }

  String toString() => keys.toList().map((key) {
        RationalNumber power = this[key];
        return power.isOne ? '$key' : '$key^$power';
      }).join('');
}

class Expression extends FractionMap<Variables>
    implements Countable<Expression> {
  Expression() : super();

  Expression.from(Map<Variables, RationalNumber> data) : super.from(data);

  Expression.constant(RationalNumber constant) : super.from({Variables(): constant});

  static Expression get consts => Expression();

  Expression get one => Expression.constant(RationalNumber.consts.one);
  Expression get zero => Expression();
  Expression get negative =>
      Expression.constant(RationalNumber.consts.negative);

  Expression get reciprocal {
    Expression newExpression = Expression();

    this.forEach((key, value) {
      newExpression[key.reciprocal] = value.reciprocal;
    });

    return newExpression;
  }

  Expression get leading => isNotEmpty
      ? Expression.from({keys.toList()[0]: values.toList()[0]})
      : Expression();

  RationalNumber get degree =>
      isNotEmpty ? keys.toList()[0].degree : RationalNumber.consts.zero;

  bool get isOne => '$this' == '1';

  bool get isZero => '$this' == '0';

  bool get isPolynomial => !this
      .keys
      .map((key) => key.values.map((value) => value.decimal >= 0))
      .expand((i) => i)
      .contains(false);

  Expression operator -() => this * negative;

  Expression operator +(Expression other) => Expression.from(this)
    ..merge(other)
    ..reduce();

  Expression operator *(Expression other) {
    Expression newExpression = Expression();

    this.forEach((key1, value1) {
      other.forEach((key2, value2) {
        RationalNumber product = value1 * value2;
        newExpression.update(key1 * key2, (prev) => prev + product,
            ifAbsent: () => product);
      });
    });

    newExpression.reduce();

    return newExpression;
  }

  Expression operator -(Expression other) => this + -other;

  static List<Expression> long_division(Expression n, Expression d) {
    if (d.isZero) return null;

    Expression q = Expression();

    while (!n.isZero) {
      Expression t = n.leading * d.leading.reciprocal;
      if (!t.isPolynomial) break;
      q += t;
      n -= t * d;
    }

    return [q, n];
  }

  List<Expression> divide(Expression other) => long_division(this, other);

  Expression operator /(Expression other) => this.divide(other)[0];

  Expression operator %(Expression other) => this.divide(other)[1];

  Expression gcd(Expression other) {
    if (!this.isZero &&
        !other.isZero &&
        (this / other).isZero &&
        (other / this).isZero) return one;

    return other.isZero ? this : other.gcd(this % other);
  }

  int get hashCode => Jenkins.hash(['$this']);

  bool operator ==(dynamic other) =>
      other is Expression && (this - other).isZero;

  String toString() {
    if (this.isNotEmpty) {
      return this.keys.map((key) {
        RationalNumber coefficient = this[key];
        return key.isEmpty ? '$coefficient' : '$coefficient$key';
      }).join(' + ');
    } else {
      return '0';
    }
  }
}
