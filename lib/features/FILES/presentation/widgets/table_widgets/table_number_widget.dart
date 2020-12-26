import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/FILES/data/models/block_table_item.dart';

class TableNumberWidget extends StatefulWidget {
  final TableItemBlock item;
  final Function(String text, TableItemBlock item) onTextChanged;
  TableNumberWidget(this.item, this.onTextChanged);

  @override
  _TableNumberCard createState() => _TableNumberCard();
}

class _TableNumberCard extends State<TableNumberWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          initialValue: widget.item.value,
          maxLines: 1,
          keyboardType: TextInputType.number,
          onChanged: (val) {
            print('onSubmited $val');
            widget.onTextChanged(val, widget.item);
          },
        ),
      ],
    );
  }
}
