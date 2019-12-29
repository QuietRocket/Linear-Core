import 'dart:collection';

import '../types/base.dart';
import '../utils/jenkins.dart';
import 'row_operation.dart';
import 'vector.dart';

class MatrixSize {
  final int rows;
  final int cols;

  const MatrixSize(this.rows, this.cols);

  int get hashCode => Jenkins.hash([rows, cols]);

  bool operator ==(dynamic other) =>
      other is MatrixSize && rows == other.rows && cols == other.cols;

  String toString() => '$rows x $cols';
}

class Matrix<T extends Arithmetic<T>>
    with ListMixin<RowVector<T>>
    implements RowOperable<T> {
  final List<RowVector<T>> data;

  Matrix(this.data);

  int get length => data.length;

  void set length(int newLength) {
    data.length = newLength;
  }

  RowVector<T> operator [](int index) => data[index];

  void operator []=(int index, RowVector<T> value) {
    data[index] = value;
  }

  int get rows => length;
  int get cols => rows == 0
      ? 0
      : this.map((vector) => vector.size).reduce((a, b) => a == b ? b : -1);

  bool get valid => cols.sign == 1;

  MatrixSize get size => MatrixSize(rows, cols);

  String toString() => '<$size, ${this.data}>';

  void rowSwap(int r1, int r2) {
    RowVector<T> temp = this[r1];
    this[r1] = this[r2];
    this[r2] = temp;
  }

  void rowScale(int r, T k) {
    for (int i = 0; i < this[r].length; i++) {
      this[r][i] *= k;
    }
  }

  void rowAdd(int r1, int r2, T k) {
    for (int i = 0; i < this[r1].length; i++) {
      this[r1][i] += this[r2][i] * k;
    }
  }
}

class AugmentedMatrix<T extends Arithmetic<T>> implements RowOperable<T> {
  final Matrix<T> coefficients;
  final ColVector<T> constants;

  const AugmentedMatrix(this.coefficients, this.constants);

  bool get valid => coefficients.valid && coefficients.rows == constants.size;

  String toString() => '<$coefficients: $constants>';

  void rowSwap(int r1, int r2) {
    coefficients.rowSwap(r1, r2);
    constants.rowSwap(r1, r2);
  }

  void rowScale(int r, T k) {
    coefficients.rowScale(r, k);
    constants.rowScale(r, k);
  }

  void rowAdd(int r1, int r2, T k) {
    coefficients.rowAdd(r1, r2, k);
    constants.rowAdd(r1, r2, k);
  }
}
