import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/utility/url_preview/url_preview.dart';
import 'package:sorted/features/FILES/presentation/todolist_bloc/todolist_bloc.dart';
import 'package:sorted/features/PLAN/data/models/todo_item.dart';

class TodoItemMenu extends StatefulWidget {
  final Function(TodoItemModel todo, int position, TodolistBloc bloc) moveUp;
  final Function(TodoItemModel todo, int position, TodolistBloc bloc) moveDown;
  final Function(TodoItemModel todo, int position, TodolistBloc bloc) delete;
  final Function(TodoItemModel todo, int position, TodolistBloc bloc) duplicate;
  final TodoItemModel todo;
  final int position;
  final TodolistBloc todoBloc;
  const TodoItemMenu({
    Key key,
    this.moveUp,
    this.moveDown,
    this.delete,
    this.duplicate,
    this.todo,
    this.position,
    this.todoBloc,
  });

  @override
  State<StatefulWidget> createState() => TodoItemMenuState();
}

class TodoItemMenuState extends State<TodoItemMenu> {
  String _url = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        margin: EdgeInsets.only(
            bottom: 0, left: 0, right: 0, top: Gparam.heightPadding),
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.only(
              topLeft: Radius.circular(12.0), topRight: Radius.circular(12.0)),
          gradient: new LinearGradient(
              colors: [
                Theme.of(context).scaffoldBackgroundColor,
                Theme.of(context).scaffoldBackgroundColor,
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 1.00),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (widget.position != 0)
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  widget.moveUp(widget.todo, widget.position, widget.todoBloc);
                },
                leading: Icon(Icons.arrow_drop_up),
                title: Text(
                  'Move up',
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontFamily: "Milliard",
                    height: 1.2,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: Gparam.textSmaller,
                  ),
                ),
              ),
            if (widget.position !=
                ((widget.todoBloc.state as TodolistLoaded).todos.length - 1))
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  widget.moveDown(
                      widget.todo, widget.position, widget.todoBloc);
                },
                leading: Icon(Icons.arrow_drop_down),
                title: Text(
                  'Move down',
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontFamily: "Milliard",
                    height: 1.2,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: Gparam.textSmaller,
                  ),
                ),
              ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                widget.delete(widget.todo, widget.position, widget.todoBloc);
              },
              leading: Icon(Icons.delete),
              title: Text(
                'Delete',
                style: TextStyle(
                  decoration: TextDecoration.none,
                  fontFamily: "Milliard",
                  height: 1.2,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: Gparam.textSmaller,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.content_copy),
              onTap: () {
                Navigator.pop(context);
                widget.duplicate(widget.todo, widget.position, widget.todoBloc);
              },
              title: Text(
                'Duplicate',
                style: TextStyle(
                  decoration: TextDecoration.none,
                  fontFamily: "Milliard",
                  height: 1.2,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: Gparam.textSmaller,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
