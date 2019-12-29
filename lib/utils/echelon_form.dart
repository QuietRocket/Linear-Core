import '../types/base.dart';
import '../structures/matrix.dart';
import '../structures/row_operation.dart';

class Pivot {
  final int row;
  final int col;

  const Pivot(this.row, this.col);
}

class EchelonForm<U extends Arithmetic<U>> {
  List<Pivot> pivots = [];
  RowOperationGroup<U> operations = RowOperationGroup([]);

  EchelonForm(this.pivots, this.operations);

  static EchelonForm<T> ref<T extends Reciprocable<T>>(Matrix<T> m) {
    EchelonForm<T> ef = EchelonForm([], RowOperationGroup([]));

    int pivot = 0;
    int rows = m.rows, cols = m.cols;
    T item;

    for (int col = 0; col < cols; col++) {
      for (int row = pivot; row < rows; row++) {
        item = m[row][col];

        if (!item.isZero) {
          ef.pivots.add(Pivot(pivot, col));
          if (!item.isOne) {
            RowOperation<T> scaleOp = RowScale(row, item.reciprocal);
            ef.operations.add(scaleOp);
            scaleOp.apply(m);
          }
          if (row != pivot) {
            RowOperation<T> swapOp = RowSwap(row, pivot);
            ef.operations.add(swapOp);
            swapOp.apply(m);
          }
          for (int i = pivot + 1; i < rows; i++) {
            item = m[i][col];
            if (!item.isZero) {
              RowOperation<T> addOp = RowAdd(i, pivot, -item);
              ef.operations.add(addOp);
              addOp.apply(m);
            }
          }

          pivot++;
          row = rows;
        }
      }
    }

    return ef;
  }

  static EchelonForm<T> rref<T extends Reciprocable<T>>(Matrix<T> m) {
    EchelonForm<T> ef = ref(m);

    ef.pivots.reversed.forEach((pivot) {
      for (int row = pivot.row - 1; row >= 0; row--) {
        if (!m[row][pivot.col].isZero) {
          RowOperation<T> addOp = RowAdd(row, pivot.row, -(m[row][pivot.col]));
          ef.operations.add(addOp);
          addOp.apply(m);
        }
      }
    });

    return ef;
  }
}
