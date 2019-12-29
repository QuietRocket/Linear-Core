import 'dart:math';

import '../types/base.dart';
import '../structures/matrix.dart';
import '../structures/vector.dart';

class PrettyPrinter {
  static const tl = '┏';
  static const tr = '┓';

  static const bl = '┗';
  static const br = '┛';

  static const v = '┃';

  static int computeMaxLength(List<String> array) =>
      array.map((i) => i.length).reduce(max);

  static String createSpacer(int size) => List.filled(size, ' ').join();

  static void printRows(
      int rows, String spacer, String Function(int i) lambda) {
    for (int i = 0; i < rows; i++) {
      if (i == 0) {
        print('$tl $spacer $tr');
      }

      print('$v ${lambda(i)} $v');

      if (i == rows - 1) {
        print('$bl $spacer $br');
      }
    }
  }

  static void vector<T extends Arithmetic<T>>(Vector<T> vec) {
    List<String> cache = vec.map((i) => '$i').toList();

    int maxLength = computeMaxLength(cache);

    printRows(cache.length, createSpacer(maxLength),
        (i) => cache[i].padLeft(maxLength));
  }

  static void matrix<T extends Arithmetic<T>>(Matrix<T> mat) {
    if (!mat.valid) {
      print('Invalid matrix');
      return;
    }

    List<List<String>> cache =
        mat.map((i) => i.map((j) => '$j').toList()).toList();

    int maxLength = computeMaxLength(cache.expand((i) => i).toList());

    printRows(cache.length, createSpacer((maxLength + 1) * mat.cols - 1),
        (i) => cache[i].map((val) => val.padLeft(maxLength)).join(' '));
  }

  static void augmented<T extends Arithmetic<T>>(AugmentedMatrix<T> am) {
    if (!am.valid) {
      print('Invalid augmented matrix');
      return;
    }

    List<List<String>> cacheM =
        am.coefficients.map((i) => i.map((j) => '$j').toList()).toList();
    int maxLengthM = computeMaxLength(cacheM.expand((i) => i).toList());

    List<String> cacheV = am.constants.map((i) => '$i').toList();
    int maxLengthV = computeMaxLength(cacheV);

    printRows(cacheM.length,
        '${createSpacer((maxLengthM + 1) * am.coefficients.cols)}$v${createSpacer(maxLengthV + 1)}',
        (i) {
      String padM = cacheM[i].map((val) => val.padLeft(maxLengthM)).join(' ');
      String padV = cacheV[i].padLeft(maxLengthV);
      return '$padM $v $padV';
    });
  }

  static void infer<T extends Arithmetic<T>>(dynamic object) {
    if (object is Vector) {
      vector(object as Vector<T>);
    } else if (object is Matrix) {
      matrix(object as Matrix<T>);
    } else if (object is AugmentedMatrix) {
      augmented(object as AugmentedMatrix<T>);
    } else {
      print(object);
    }
  }
}
