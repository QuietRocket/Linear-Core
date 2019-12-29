import 'dart:collection';

import '../types/base.dart';
import 'row_operation.dart';

enum VectorType { row, col }

class Vector<T extends Arithmetic<T>>
    with ListMixin<T>
    implements RowOperable<T> {
  final VectorType type;
  final List<T> data;

  Vector(this.type, this.data);

  int get length => data.length;

  void set length(int newLength) {
    data.length = newLength;
  }

  T operator [](int index) => data[index];

  void operator []=(int index, T value) {
    data[index] = value;
  }

  int get size => length;

  String toString() => '<$type: ${this.data}>';

  void rowSwap(int r1, int r2) {
    T temp = this[r1];
    this[r1] = this[r2];
    this[r2] = temp;
  }

  void rowScale(int r, T k) {
    this[r] *= k;
  }

  void rowAdd(int r1, int r2, T k) {
    this[r1] += this[r2] * k;
  }
}

class RowVector<T extends Arithmetic<T>> extends Vector<T> {
  RowVector(List<T> data) : super(VectorType.row, data);
}

class ColVector<T extends Arithmetic<T>> extends Vector<T> {
  ColVector(List<T> data) : super(VectorType.col, data);
}
