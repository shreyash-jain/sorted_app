import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/utility/measure_child.dart';
import 'package:sorted/core/global/widgets/fade_route.dart';
import 'package:sorted/core/global/widgets/loading_widget.dart';
import 'package:sorted/core/global/widgets/message_display.dart';
import 'package:sorted/features/FILES/data/models/block_column.dart';
import 'package:sorted/features/FILES/data/models/block_info.dart';
import 'package:sorted/features/FILES/data/models/block_textbox.dart';
import 'package:sorted/features/FILES/presentation/note_bloc/note_bloc.dart';
import 'package:sorted/features/FILES/presentation/table_bloc/table_bloc.dart';

import 'package:sorted/features/FILES/presentation/textbox_bloc/textbox_bloc.dart';
import 'package:sorted/features/FILES/presentation/todolist_bloc/todolist_bloc.dart';
import 'package:sorted/features/FILES/presentation/widgets/textbox_edit.dart';
import 'package:sorted/features/HOME/data/models/affirmation.dart';
import 'package:sorted/features/HOME/domain/entities/day_affirmations.dart';
import 'package:sorted/features/PLAN/data/models/todo_item.dart';

import 'package:zefyr/zefyr.dart';
import 'dart:convert';
import 'package:quill_delta/quill_delta.dart';

class TableWidget extends StatefulWidget {
  final BlockInfo blockInfo;
  final NoteBloc noteBloc;

  final Function(BlockInfo blockInfo) updateBlockInfo;
  final Function(int decoration) updateDecoration;

  const TableWidget({
    Key key,
    this.blockInfo,
    this.updateBlockInfo,
    this.updateDecoration,
    this.noteBloc,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => TableWidgetState();
}

class TableWidgetState extends State<TableWidget> {
  double height = 10;

  NotusDocument document;

  var _focusNode = FocusNode();
  TableBloc bloc;

  FocusNode newTodoFocus = FocusNode();

  ScrollController _listScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    print("Load todolist " + widget.blockInfo.toString());
    bloc = BlocProvider.of<TableBloc>(context);
    BlocProvider.of<TableBloc>(context)
      ..add(UpdateTable(widget.blockInfo, context));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("textbox build");
    return Center(
        child: BlocBuilder<TableBloc, TableState>(builder: (context, state) {
      if (state is TableError) {
        return MessageDisplay(
          message: state.message,
        );
      } else if (state is TableInitial) {
        return Center(
            child: Container(
          height: 0,
          width: 0,
        ));
      } else if (state is TableLoaded) {
        print("update state");
        return MeasureSize(
            onChange: (Size size) {
              print("child measured");
              if (state.blockInfo.height != size.height)
                widget.updateBlockInfo(
                    widget.blockInfo.copyWith(height: size.height));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 8,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DataTable(
                          horizontalMargin: Gparam.widthPadding,
                          showCheckboxColumn: true,
                          headingRowHeight: 30,
                          columns: state.cols.toList(),
                          rows: state.rows.toList()),
                      SizedBox(
                        width: 8,
                      ),
                      GestureDetector(
                        onTap: () {
                          bloc.add(AddNewColumn(context,
                              (bloc.state as TableLoaded).cols.length));
                        },
                        child: Container(
                          height: 30,
                          child: Row(children: [
                            Icon(Icons.add, size: 12),
                            Text("Add")
                          ]),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                GestureDetector(
                  onTap: () {
                    bloc.add(AddNewRow(
                        context, (bloc.state as TableLoaded).cols.length));
                  },
                  child: Row(children: [
                    SizedBox(width: Gparam.widthPadding),
                    Icon(Icons.add, size: 12),
                    Text("Add")
                  ]),
                ),
                SizedBox(
                  height: 8,
                ),
              ],
            ));
      }
    }));
  }
}
