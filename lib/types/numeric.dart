import '../utils/jenkins.dart';
import 'base.dart';

class Numeric implements Reciprocable<Numeric> {
  final num number;

  const Numeric(this.number);

  static const Numeric consts = Numeric(null);

  Numeric get one => Numeric(1);
  Numeric get zero => Numeric(0);
  Numeric get negative => Numeric(-1);

  Numeric get reciprocal => Numeric(1 / number);

  bool get isOne => this == one;

  bool get isZero => this == zero;

  Numeric operator -() => this * negative;

  Numeric operator +(Numeric other) => Numeric(number + other.number);

  Numeric operator *(Numeric other) => Numeric(number * other.number);

  Numeric operator -(Numeric other) => this + -other;

  Numeric operator /(Numeric other) => this * other.reciprocal;

  int get hashCode => Jenkins.hash([number]);

  bool operator ==(dynamic other) => other is Numeric && number == other.number;

  String toString() => '$number';
}
