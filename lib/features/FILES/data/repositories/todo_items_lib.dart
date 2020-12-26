import 'package:equatable/equatable.dart';
import 'package:sorted/features/FILES/presentation/widgets/todo_item_menu.dart';
import 'package:sorted/features/PLAN/data/models/todo_item.dart';

class TodoLib {
  TodoLib._();

  static final TodoLib lib = TodoLib._();

  List<TodoItemModel> getGroceriesItem() {
    return [
      TodoItemModel(
          id: 1,
          todoItem: "Milk",
          url:
              "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/todo_library%2Fgroceries%2Fmilk.png?alt=media&token=4c44f18d-4830-4ec2-93a3-17674a3ea960",
          value: 1),
      TodoItemModel(
          id: 1,
          todoItem: "Rice",
          url:
              "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/todo_library%2Fgroceries%2Frice.png?alt=media&token=82fdeea0-50a9-4100-a42c-fc9b850a9796",
          value: 1),
      TodoItemModel(
          id: 1,
          todoItem: "Sugar",
          url:
              "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/todo_library%2Fgroceries%2Fsugar.png?alt=media&token=8ff435ed-7a12-4510-9f7d-03b8d6b3785f",
          value: 1),
      TodoItemModel(
          id: 1,
          todoItem: "Salt",
          url:
              "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/todo_library%2Fgroceries%2Fsalt.png?alt=media&token=6a5e46a6-1adb-4898-aada-d2b5da200ec9",
          value: 1),
    ];
  }
}
