import 'dart:collection';

enum OperationType { swap, scale, add }

abstract class RowOperable<T> {
  void rowSwap(int r1, int r2);
  void rowScale(int r, T k);
  void rowAdd(int r1, int r2, T k);
}

abstract class RowOperation<T> {
  final OperationType type;

  void apply(RowOperable<T> target);

  const RowOperation(this.type);
}

class RowSwap<T> extends RowOperation<T> {
  final int r1, r2;

  void apply(RowOperable<T> target) {
    target.rowSwap(r1, r2);
  }

  const RowSwap(this.r1, this.r2) : super(OperationType.swap);

  String toString() => 'R${r1 + 1} <-> R${r2 + 1}';
}

class RowScale<T> extends RowOperation<T> {
  final int r;
  final T k;

  void apply(RowOperable<T> target) {
    target.rowScale(r, k);
  }

  const RowScale(this.r, this.k) : super(OperationType.scale);

  String toString() => 'R${r + 1} -> ${k} * R${r + 1}';
}

class RowAdd<T> extends RowOperation<T> {
  final int r1, r2;
  final T k;

  void apply(RowOperable<T> target) {
    target.rowAdd(r1, r2, k);
  }

  const RowAdd(this.r1, this.r2, this.k) : super(OperationType.add);

  String toString() => 'R${r1 + 1} -> R${r1 + 1} + ${k} * R${r2 + 1}';
}

class RowOperationGroup<T> with ListMixin<RowOperation<T>> {
  final List<RowOperation<T>> operations;

  int get length => operations.length;

  void set length(int newLength) {
    operations.length = newLength;
  }

  RowOperation<T> operator [](int index) => operations[index];

  void operator []=(int index, RowOperation<T> value) {
    operations[index] = value;
  }

  void apply(RowOperable<T> target) {
    operations.forEach((operation) {
      operation.apply(target);
    });
  }

  RowOperationGroup(this.operations);
}
