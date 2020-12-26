import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/FILES/data/models/block_table_item.dart';

class TableDateWidget extends StatefulWidget {
  final TableItemBlock item;
  final Function(String text, TableItemBlock item) onTextChanged;
  TableDateWidget(this.item, this.onTextChanged);

  @override
  _TableDateCard createState() => _TableDateCard();
}

class _TableDateCard extends State<TableDateWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          initialValue: widget.item.value,
          keyboardType: TextInputType.datetime,
          onChanged: (val) {
            print('onSubmited $val');
            widget.onTextChanged(val, widget.item);
          },
        ),
      ],
    );
  }
}
