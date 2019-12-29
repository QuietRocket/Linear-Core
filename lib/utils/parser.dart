import '../types/precise.dart';
import '../types/rational_number.dart';
import '../types/symbolic.dart';

class Parser {
  static RationalNumber fraction(String input) {
    input = input.replaceAll(' ', '');
    RegExp pattern = RegExp(r'^((?:\+|\-)?\d+)(?:\/((?:\+|\-)?\d+))?$');
    if (pattern.hasMatch(input)) {
      Match match = pattern.firstMatch(input);
      BigInt numerator =
          match.group(1) == null ? BigInt.one : BigInt.tryParse(match.group(1));
      BigInt denominator =
          match.group(2) == null ? BigInt.one : BigInt.tryParse(match.group(2));
      return RationalNumber(Precise(numerator), Precise(denominator));
    } else {
      return null;
    }
  }

  static Variables variables(String input) {
    input = input.replaceAll(' ', '');
    RegExp pattern =
        RegExp(r'([a-z])(?:\^((?:\+|\-)?\d+(?:\/(?:\+|\-)?\d+)?))?');
    if (pattern.hasMatch(input)) {
      Variables newVariables = Variables();
      pattern.allMatches(input).forEach((match) {
        newVariables[match.group(1)] = match.group(2) == null
            ? RationalNumber.consts.one
            : Parser.fraction(match.group(2));
      });
      return newVariables;
    } else {
      return null;
    }
  }

  static Expression expression(String input) {
    input = input.replaceAll(' ', '');
    RegExp pattern = RegExp(
        r'((?:\+|\-)?\d+(?:\/(?:\+|\-)?\d+)?)((?:[a-z](?:\^(?:\+|\-)?\d+(?:\/(?:\+|\-)?\d+)?)?)*)');
    if (pattern.hasMatch(input)) {
      Expression newExpression = Expression();
      pattern.allMatches(input).forEach((match) {
        Variables variables = Parser.variables(match.group(2));
        variables = variables == null ? Variables() : variables;
        newExpression +=
            Expression.from({variables: Parser.fraction(match.group(1))});
      });
      return newExpression;
    } else {
      return null;
    }
  }

  static Expression Function(String) parse = expression;
}
