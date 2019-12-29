import '../utils/jenkins.dart';
import 'base.dart';

class Precise implements Countable<Precise> {
  final BigInt number;

  const Precise(this.number);

  Precise.from(int number) : this.number = BigInt.from(number);

  static const Precise consts = Precise(null);

  Precise get one => Precise(BigInt.one);
  Precise get zero => Precise(BigInt.zero);
  Precise get negative => Precise(BigInt.from(-1));

  bool get isOne => this == one;

  bool get isZero => this == zero;

  Precise operator -() => this * negative;

  Precise operator +(Precise other) => Precise(number + other.number);

  Precise operator *(Precise other) => Precise(number * other.number);

  Precise operator -(Precise other) => this + -other;

  Precise operator /(Precise other) => Precise(this.number ~/ other.number);

  int get hashCode => Jenkins.hash([number]);

  bool operator ==(dynamic other) => other is Precise && number == other.number;

  String toString() => '$number';
}
