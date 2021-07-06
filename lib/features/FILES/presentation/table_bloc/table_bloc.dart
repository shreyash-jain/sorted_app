import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/FILES/data/models/block_column.dart';
import 'package:sorted/features/FILES/data/models/block_info.dart';
import 'package:sorted/features/FILES/data/models/block_table.dart';
import 'package:sorted/features/FILES/data/models/block_table_item.dart';
import 'package:sorted/features/FILES/data/models/block_textbox.dart';
import 'package:sorted/features/FILES/domain/repositories/note_repository.dart';
import 'package:sorted/features/FILES/presentation/note_bloc/note_bloc.dart';
import 'package:sorted/features/FILES/presentation/widgets/add_column.dart';
import 'package:sorted/features/FILES/presentation/widgets/table_widgets/table_checkbox_widget.dart';
import 'package:sorted/features/FILES/presentation/widgets/table_widgets/table_date_widget.dart';
import 'package:sorted/features/FILES/presentation/widgets/table_widgets/table_email_widget.dart';
import 'package:sorted/features/FILES/presentation/widgets/table_widgets/table_link_widget.dart';
import 'package:sorted/features/FILES/presentation/widgets/table_widgets/table_number_widget.dart';
import 'package:sorted/features/FILES/presentation/widgets/table_widgets/table_phone_widget.dart';
import 'package:sorted/features/FILES/presentation/widgets/table_widgets/table_text_widget.dart';
import 'package:sorted/features/PLAN/data/models/todo.dart';
import 'package:sorted/features/PLAN/data/models/todo_item.dart';
import 'package:sorted/features/PLAN/domain/repositories/todo_repository.dart';
import 'package:zefyr/zefyr.dart';
part 'table_event.dart';
part 'table_state.dart';

class TableBloc extends Bloc<TableEvent, TableState> {
  final NoteRepository noteRepository;

  final NoteBloc noteBloc;
  TableBloc(this.noteRepository, this.noteBloc) : super(TableInitial());
  @override
  Stream<TableState> mapEventToState(
    TableEvent event,
  ) async* {
    if (event is UpdateTable) {
      print("UpdateTable  " + event.block.id.toString());
      Failure failure;
      TableBlock table;
      List<DataColumn> dColumns = [];
      var tableOrFailure =
          await noteRepository.getTableBlock(event.block.itemId);
      tableOrFailure.fold((l) {
        failure = l;
      }, (r) {
        table = r;
        print("UpdateTable " + r.toString());
      });
      List<ColumnBlock> columns;
      var columnsOrFailure =
          await noteRepository.getTableColumnsBlock(table.id);
      columnsOrFailure.fold((l) {
        failure = l;
      }, (r) {
        columns = r;
        print("UpdateCols " + r.toString());
        r.forEach((element) {
          print(element.tableId.toString() + "hilio");
          dColumns.add(DataColumn(
              numeric: element.type == 1,
              label: InkWell(
                  onTap: () {
                    print(element.tableId.toString() + "hilio");
                    this.add(OpenColumnMenu(event.context, element));
                  },
                  child: Container(
                      height: 30,
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Icon(
                            getColumnIcon(element.type),
                            size: 18,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            element.title,
                            style: TextStyle(
                                fontFamily: 'Milliard',
                                fontSize: Gparam.textSmaller,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      )))));
        });
      });
      List<List<TableItemBlock>> cols = [];
      List<List<TableItemBlock>> rows = [];

      List<DataRow> dRows = [];

      for (int i = 0; i < columns.length; i++) {
        List<TableItemBlock> colItems = [];
        List<TableItemBlock> colItemsTyped = [];
        var itemsOrFailure =
            await noteRepository.getTableColumnsItems(columns[i].id);
        itemsOrFailure.fold((l) {
          failure = l;
        }, (r) {
          colItems = r;
          colItems.forEach((c) {
            colItemsTyped.add(c.copyWith(type: columns[i].type));
          });
        });
        cols.add(colItemsTyped);
      }
      rows = transpose(cols);
      int j = 0;
      for (int k = 0; k < rows.length; k++) {
        j = j + 1;
        List<DataCell> cells = [];
        rows[k].forEach((element) {
          cells.add(
            DataCell(getTableWidget(element.type, element),
                showEditIcon: false),
          );
        });
        dRows.add(DataRow(
          cells: cells,
          color: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            // Even rows will have a grey color.
            if (k % 2 == 0) return Colors.grey.withOpacity(0.1);
            return null; // Use default value for other states and odd rows.
          }),
        ));
      }
      ColumnBlock cBlock = new ColumnBlock();

      if (failure == null)
        yield TableLoaded(
            dColumns, dRows, table, event.block, cBlock, rows, columns);
    } else if (event is UpdateTypeEvent) {
      List<DataRow> dRows = [];
      List<DataColumn> dColumns = [];
      List<List<TableItemBlock>> prevRows = (state as TableLoaded).databaseRows;
      List<List<TableItemBlock>> newRows = [];
      List<ColumnBlock> prevColumns = (state as TableLoaded).databaseColumns;
      List<ColumnBlock> newColumns = [];

      for (int itr = 0; itr < prevColumns.length; itr++) {
        if (prevColumns[itr].id != event.col.id)
          newColumns.add(prevColumns[itr]);
        else
          newColumns.add(event.col);
      }
      newColumns.forEach((element) {
        print(element.tableId.toString() + "hilio");

        dColumns.add(DataColumn(
            label: InkWell(
                onTap: () {
                  print(element.tableId.toString() + "hilio");
                  this.add(OpenColumnMenu(event.context, element));
                },
                child: Container(
                    height: 30,
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Icon(
                          getColumnIcon(element.type),
                          size: 18,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          element.title,
                          style: TextStyle(
                              fontFamily: 'Milliard',
                              fontSize: Gparam.textSmaller,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    )))));
      });
      List<List<TableItemBlock>> cols = [];
      List<List<TableItemBlock>> rows = [];
      Failure failure;

      for (int i = 0; i < newColumns.length; i++) {
        List<TableItemBlock> colItems = [];
        List<TableItemBlock> colItemsTyped = [];
        var itemsOrFailure =
            await noteRepository.getTableColumnsItems(newColumns[i].id);
        itemsOrFailure.fold((l) {
          failure = l;
        }, (r) {
          colItems = r;
          colItems.forEach((c) {
            colItemsTyped.add(c.copyWith(type: newColumns[i].type));
          });
        });
        cols.add(colItemsTyped);
      }
      rows = transpose(cols);
      int j = 0;
      for (int k = 0; k < rows.length; k++) {
        j = j + 1;
        List<DataCell> cells = [];
        rows[k].forEach((element) {
          cells.add(
            DataCell(getTableWidget(element.type, element),
                showEditIcon: false),
          );
        });
        dRows.add(DataRow(
          cells: cells,
          color: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            // Even rows will have a grey color.
            if (k % 2 == 0) return Colors.grey.withOpacity(0.1);
            return null; // Use default value for other states and odd rows.
          }),
        ));
      }

      yield TableLoaded(
        dColumns,
        dRows,
        (state as TableLoaded).table,
        (state as TableLoaded).blockInfo,
        event.col,
        rows,
        newColumns,
      );

      noteRepository.updateTableColumn(event.col);
    } else if (event is UpdateColumnNameEvent) {
      List<DataRow> dRows = [];
      List<DataColumn> dColumns = [];
      List<List<TableItemBlock>> prevRows = (state as TableLoaded).databaseRows;
      List<List<TableItemBlock>> newRows = [];
      List<ColumnBlock> prevColumns = (state as TableLoaded).databaseColumns;
      List<ColumnBlock> newColumns = [];

      for (int itr = 0; itr < prevColumns.length; itr++) {
        if (prevColumns[itr].id != event.col.id)
          newColumns.add(prevColumns[itr]);
        else
          newColumns.add(event.col);
      }
      newColumns.forEach((element) {
        print(element.tableId.toString() + "hilio");

        dColumns.add(DataColumn(
            label: InkWell(
                onTap: () {
                  print(element.tableId.toString() + "hilio");
                  this.add(OpenColumnMenu(event.context, element));
                },
                child: Container(
                    height: 30,
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Icon(
                          getColumnIcon(element.type),
                          size: 18,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          element.title,
                          style: TextStyle(
                              fontFamily: 'Milliard',
                              fontSize: Gparam.textSmaller,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    )))));
      });

      yield TableLoaded(
        dColumns,
        (state as TableLoaded).rows,
        (state as TableLoaded).table,
        (state as TableLoaded).blockInfo,
        event.col,
        (state as TableLoaded).databaseRows,
        newColumns,
      );
      noteRepository.updateTableColumn(event.col);
    } else if (event is UpdateColumnNameEvent) {
      print("hello  " + event.col.toString());
      yield TableLoaded(
          (state as TableLoaded).cols,
          (state as TableLoaded).rows,
          (state as TableLoaded).table,
          (state as TableLoaded).blockInfo,
          event.col,
          (state as TableLoaded).databaseRows,
          (state as TableLoaded).databaseColumns);
      print(event.col.toString() + "heeleo");
      print(event.col.tableId.toString() + "heeleo");

      noteRepository.updateTableColumn(event.col);
      print(event.col.toString() + "heeleo");
      print(event.col.tableId.toString() + "heeleo");

      noteRepository.updateTableColumn(event.col);
    } else if (event is OpenColumnMenu) {
      print(event.col.tableId.toString() + "heeleos1");
      yield TableLoaded(
        (state as TableLoaded).cols,
        (state as TableLoaded).rows,
        (state as TableLoaded).table,
        (state as TableLoaded).blockInfo,
        event.col,
        (state as TableLoaded).databaseRows,
        (state as TableLoaded).databaseColumns,
      );

      _editColumnMenuSheet(event.context, this);
    } else if (event is AddNewRow) {
      List<List<TableItemBlock>> prevDataRows =
          (state as TableLoaded).databaseRows;
      List<List<TableItemBlock>> updatedDataRows =
          new List<List<TableItemBlock>>.from(prevDataRows);
      List<ColumnBlock> prevDataColumns =
          (state as TableLoaded).databaseColumns;
      TableBlock prevTable = (state as TableLoaded).table;
      List<DataRow> prevRows = (state as TableLoaded).rows;
      List<DataRow> updatedRows = prevRows;
      List<DataColumn> prevCols = (state as TableLoaded).cols;
      DateTime now = DateTime.now();

      List<TableItemBlock> newItems = [];
      List<DataCell> newRowCells = [];
      prevTable = prevTable.copyWith(rows: prevTable.rows + 1);

      for (int i = 0; i < prevCols.length; i++) {
        TableItemBlock newItem = TableItemBlock(
            id: now.millisecondsSinceEpoch + i,
            colId: prevDataColumns[i].id,
            type: prevDataColumns[i].type);
        noteRepository.addTableColumnItem(newItem);

        newItems.add(newItem);
        newRowCells.add(
          DataCell(getTableWidget(newItem.type, newItem), showEditIcon: false),
        );
      }
      updatedRows.add(DataRow(
        cells: newRowCells,
        color: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          // Even rows will have a grey color.
          if (prevCols.length % 2 == 0) return Colors.grey.withOpacity(0.1);
          return null; // Use default value for other states and odd rows.
        }),
      ));
      updatedDataRows.add(newItems);

      yield TableLoaded(
        prevCols,
        updatedRows,
        prevTable,
        (state as TableLoaded).blockInfo,
        (state as TableLoaded).editColumn,
        updatedDataRows,
        prevDataColumns,
      );
    } else if (event is AddNewColumn) {
      List<List<TableItemBlock>> prevDataRows =
          (state as TableLoaded).databaseRows;
      List<List<TableItemBlock>> updatedDataRows =
          new List<List<TableItemBlock>>.from(prevDataRows);
      List<ColumnBlock> prevDataColumns =
          (state as TableLoaded).databaseColumns;
      TableBlock prevTable = (state as TableLoaded).table;
      List<DataRow> prevRows = (state as TableLoaded).rows;
      List<DataRow> updatedRows = prevRows;
      List<DataColumn> prevCols = (state as TableLoaded).cols;
      DateTime now = DateTime.now();

      ColumnBlock newColumn = ColumnBlock(
          id: now.millisecondsSinceEpoch,
          title: "Col ${prevCols.length + 1}",
          position: prevCols.length,
          tableId: prevTable.id);
      prevTable = prevTable.copyWith(cols: prevTable.cols + 1);
      noteRepository.addTableColumn(newColumn);

      prevDataColumns.add(newColumn);
      prevCols.add(DataColumn(
          label: InkWell(
              onTap: () {
                print(newColumn.tableId.toString() + "hilio");
                this.add(OpenColumnMenu(event.context, newColumn));
              },
              child: Container(
                  height: 30,
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Icon(
                        getColumnIcon(newColumn.type),
                        size: 18,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        newColumn.title,
                        style: TextStyle(
                            fontFamily: 'Milliard',
                            fontSize: Gparam.textSmaller,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  )))));

      List<TableItemBlock> newItems = [];

      for (int i = 0; i < prevRows.length; i++) {
        TableItemBlock newItem = TableItemBlock(
            id: now.millisecondsSinceEpoch + i, colId: newColumn.id);
        noteRepository.addTableColumnItem(newItem);
        updatedRows[i].cells.add(
              DataCell(getTableWidget(newItem.type, newItem),
                  showEditIcon: false),
            );
        newItems.add(newItem);
        List<TableItemBlock> tempRow =
            new List<TableItemBlock>.from(updatedDataRows[i]);
        tempRow.add(newItem);

        updatedDataRows[i] = tempRow;
      }

      yield TableLoaded(
        prevCols,
        updatedRows,
        prevTable,
        (state as TableLoaded).blockInfo,
        (state as TableLoaded).editColumn,
        updatedDataRows,
        prevDataColumns,
      );

      noteRepository.updateTableBlock(prevTable);
    } else if (event is UpdateTableItem) {
      List<List<TableItemBlock>> rows = (state as TableLoaded).databaseRows;
      List<DataRow> dRows = [];
      for (int k = 0; k < rows.length; k++) {
        List<DataCell> cells = [];
        List<TableItemBlock> updatedRow = [];
        for (int it = 0; it < rows[k].length; it++) {
          if (rows[k][it].id != event.item.id) {
            updatedRow.add(rows[k][it]);
          } else {
            updatedRow.add(event.item);
          }
        }
        updatedRow.forEach((element) {
          cells.add(
            DataCell(getTableWidget(element.type, element),
                showEditIcon: false),
          );
        });

        dRows.add(DataRow(
          cells: cells,
          color: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            // Even rows will have a grey color.
            if (k % 2 == 0) return Colors.grey.withOpacity(0.1);
            return null; // Use default value for other states and odd rows.
          }),
        ));
        rows[k] = updatedRow;
      }

      yield TableLoaded(
        (state as TableLoaded).cols,
        dRows,
        (state as TableLoaded).table,
        (state as TableLoaded).blockInfo,
        (state as TableLoaded).editColumn,
        rows,
        (state as TableLoaded).databaseColumns,
      );
      noteRepository.updateTableColumnItem(event.item);
    }
  }

  Widget getTableWidget(int type, TableItemBlock item) {
    print("sheezo  " + type.toString());
    if (type == 0)
      return TableTextWidget(item, onTextChanged);
    else if (type == 1)
      return TableNumberWidget(item, onTextChanged);
    else if (type == 2)
      return TableDateWidget(item, onTextChanged);
    else if (type == 3)
      return TableLinkWidget(item, onTextChanged);
    else if (type == 4)
      return TableCheckboxWidget(item, onBoolChanged);
    else if (type == 5)
      return TableEmailWidget(item, onTextChanged);
    else if (type == 6) return TablePhoneWidget(item, onTextChanged);
  }

  IconData getColumnIcon(int type) {
    print("sheezo  " + type.toString());
    if (type == 0)
      return (Icons.title);
    else if (type == 1)
      return (Icons.format_list_numbered);
    else if (type == 2)
      return (Icons.date_range);
    else if (type == 3)
      return (Icons.link);
    else if (type == 4)
      return (Icons.check_box);
    else if (type == 5)
      return (Icons.email);
    else if (type == 6) return (Icons.ring_volume);
    return Icons.devices_other;
  }

  void _editColumnMenuSheet(context, TableBloc tableBloc) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.0))),
        backgroundColor: Colors.transparent,
        context: myGlobals.scaffoldKey.currentContext,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return AddColumnBottomSheet(
              onTypeChanged: (int type) {
                setState(() {
                  tableBloc.add(UpdateTypeEvent(
                      (this.state as TableLoaded)
                          .editColumn
                          .copyWith(type: type),
                      context));
                });
              },
              columnBlock: (this.state as TableLoaded).editColumn,
              onHeadingChanged: (String text) {
                Navigator.pop(context);
                print(
                    (this.state as TableLoaded).editColumn.tableId.toString() +
                        "heeleos");

                setState(() {
                  tableBloc.add(UpdateColumnNameEvent(
                      (this.state as TableLoaded)
                          .editColumn
                          .copyWith(title: text),
                      context));
                });
              },
            );
          });
        });
  }

  List<List<T>> transpose<T>(List<List<T>> colsInRows) {
    int nRows = colsInRows.length;
    if (colsInRows.length == 0) return colsInRows;

    int nCols = colsInRows[0].length;
    if (nCols == 0) throw new StateError("Degenerate matrix");

    // Init the transpose to make sure the size is right
    List<List<T>> rowsInCols = new List(nCols);
    for (int col = 0; col < nCols; col++) {
      rowsInCols[col] = new List(nRows);
    }

    // Transpose
    for (int row = 0; row < nRows; row++) {
      for (int col = 0; col < nCols; col++) {
        rowsInCols[col][row] = colsInRows[row][col];
      }
    }
    return rowsInCols;
  }

  @override
  Future<void> close() {
    print(" update textbox");

    return super.close();
  }

  onTextChanged(String text, TableItemBlock item) {
    this.add(UpdateTableItem(item.copyWith(value: text)));
  }

  onBoolChanged(bool value, TableItemBlock item) {
    if (value) {
      this.add(UpdateTableItem(item.copyWith(value: "true")));
    } else {
      this.add(UpdateTableItem(item.copyWith(value: "")));
    }
  }
}
