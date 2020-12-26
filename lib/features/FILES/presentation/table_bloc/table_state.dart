part of 'table_bloc.dart';

abstract class TableState extends Equatable {
  const TableState();
}

class TableInitial extends TableState {
  @override
  List<Object> get props => [];
}

class TableLoaded extends TableState {
  final TableBlock table;
  final BlockInfo blockInfo;
  final List<DataColumn> cols;
  final List<ColumnBlock> databaseColumns;
  final List<List<TableItemBlock>> databaseRows;
  final List<DataRow> rows;
  final ColumnBlock editColumn;

  TableLoaded(
      this.cols, this.rows, this.table, this.blockInfo, this.editColumn,this.databaseRows,this.databaseColumns);
  @override
  List<Object> get props => [table, rows, cols, blockInfo, editColumn, databaseRows, databaseColumns];
}

class TableError extends TableState {
  final String message;

  TableError({this.message});

  @override
  List<Object> get props => [message];
}
