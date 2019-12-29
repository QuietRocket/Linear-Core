import 'precise.dart';
import 'rational.dart';

class RationalNumber extends Rational<Precise, RationalNumber> {
  const RationalNumber(Precise numerator, Precise denominator)
      : super(numerator, denominator);

  RationalNumber Function(Precise, Precise) get constructor =>
      (numerator, denominator) => RationalNumber(numerator, denominator);

  RationalNumber.from(int numerator, int denominator)
      : super(Precise.from(numerator), Precise.from(denominator));

  RationalNumber.whole(int number)
      : super(Precise.from(number), Precise.consts.one);

  static const RationalNumber consts = RationalNumber(null, null);

  RationalNumber get one => RationalNumber.whole(1);
  RationalNumber get zero => RationalNumber.whole(0);
  RationalNumber get negative => RationalNumber.whole(-1);

  RationalNumber get reduced {
    BigInt numerator = this.numerator.number.abs(),
        denominator = this.denominator.number.abs();

    numerator *=
        BigInt.from(this.numerator.number.sign * this.denominator.number.sign);

    BigInt divisor = numerator.gcd(denominator);

    return RationalNumber(
        Precise(numerator ~/ divisor), Precise(denominator ~/ divisor));
  }

  double get decimal => numerator.number / denominator.number;
}
