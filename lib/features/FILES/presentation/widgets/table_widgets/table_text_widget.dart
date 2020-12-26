import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/FILES/data/models/block_table_item.dart';

class TableTextWidget extends StatefulWidget {
  final TableItemBlock item;
  final Function(String text, TableItemBlock item) onTextChanged;
  TableTextWidget(this.item, this.onTextChanged);

  @override
  _TableTextCard createState() => _TableTextCard();
}

class _TableTextCard extends State<TableTextWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          initialValue: widget.item.value,
          onChanged: (val) {
            print('onSubmited $val');
            widget.onTextChanged(val, widget.item);
          },
        ),
      ],
    );
  }
}
