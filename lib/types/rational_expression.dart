import '../utils/parser.dart';
import 'rational.dart';
import 'symbolic.dart';

class RationalExpression extends Rational<Expression, RationalExpression> {
  const RationalExpression(Expression numerator, Expression denominator)
      : super(numerator, denominator);

  RationalExpression Function(Expression, Expression) get constructor =>
      (numerator, denominator) => RationalExpression(numerator, denominator);

  RationalExpression.from(String numerator, String denominator)
      : super(Parser.parse(numerator), Parser.parse(denominator));

  RationalExpression.whole(String expression)
      : super(Parser.parse(expression), Expression.consts.one);

  static const RationalExpression consts = RationalExpression(null, null);

  RationalExpression get one =>
      RationalExpression(Expression.consts.one, Expression.consts.one);
  RationalExpression get zero =>
      RationalExpression(Expression.consts.zero, Expression.consts.one);
  RationalExpression get negative =>
      RationalExpression(Expression.consts.negative, Expression.consts.one);

  RationalExpression get reduced {
    if (this.numerator.isZero) {
      return zero;
    } else if (this.denominator.isOne) {
      return this;
    } else {
      Expression numerator = this.numerator, denominator = this.denominator;

      Expression divisor = numerator.gcd(denominator);

      return RationalExpression(numerator / divisor, denominator / divisor);
    }
  }
}
