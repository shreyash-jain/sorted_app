part of 'table_bloc.dart';

abstract class TableEvent extends Equatable {
  const TableEvent();
}

class UpdateTable extends TableEvent {
  final BlockInfo block;
  final BuildContext context;
  UpdateTable(this.block, this.context);

  @override
  List<Object> get props => [block, context];
}

class UpdateTypeEvent extends TableEvent {
  final ColumnBlock col;
  final BuildContext context;

  UpdateTypeEvent(this.col, this.context);

  @override
  List<Object> get props => [col, context];
}

class UpdateColumnNameEvent extends TableEvent {
  final ColumnBlock col;
  final BuildContext context;

  UpdateColumnNameEvent(this.col, this.context);

  @override
  List<Object> get props => [col, context];
}

class UpdateTableItem extends TableEvent {
  final TableItemBlock item;

  UpdateTableItem(this.item);

  @override
  List<Object> get props => [item];
}

class AddNewColumn extends TableEvent {
  final BuildContext context;
  final int position;

  AddNewColumn(this.context, this.position);

  @override
  List<Object> get props => [context, position];
}

class AddNewRow extends TableEvent {
  final BuildContext context;
  final int position;

  AddNewRow(this.context, this.position);

  @override
  List<Object> get props => [context, position];
}

class OpenColumnMenu extends TableEvent {
  final BuildContext context;
  final ColumnBlock col;

  OpenColumnMenu(this.context, this.col);

  @override
  List<Object> get props => [context, col];
}
