import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/FILES/data/models/block_table_item.dart';

class TableCheckboxWidget extends StatefulWidget {
  final TableItemBlock item;
  final Function(bool text, TableItemBlock item) onBoolChanged;
  TableCheckboxWidget(this.item, this.onBoolChanged);

  @override
  _TableCheckboxCard createState() => _TableCheckboxCard();
}

class _TableCheckboxCard extends State<TableCheckboxWidget> {
  bool value = false;
  @override
  void initState() {
    value = widget.item.value.isNotEmpty;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Checkbox(
            value: value,
            checkColor: Theme.of(context).scaffoldBackgroundColor,
            activeColor: Theme.of(context).primaryColor,
            focusColor: Theme.of(context).primaryColor,
            hoverColor: Theme.of(context).primaryColor,
            onChanged: (b) {
              setState(() {
                value = !value;
              });
              widget.onBoolChanged(b, widget.item);
            })
      ],
    );
  }
}
