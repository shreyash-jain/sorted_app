import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/FILES/data/models/block_table_item.dart';
import 'package:url_launcher/url_launcher.dart';

class TablePhoneWidget extends StatefulWidget {
  final TableItemBlock item;
  final Function(String text, TableItemBlock item) onTextChanged;
  TablePhoneWidget(this.item, this.onTextChanged);

  @override
  _TablePhoneCard createState() => _TablePhoneCard();
}

class _TablePhoneCard extends State<TablePhoneWidget> {
  TextEditingController phoneController;
  @override
  void initState() {
    phoneController = TextEditingController(text: widget.item.value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.only(top: 20), // add padding to adjust text
              isDense: true,
              hintText: "Phone",
              suffixIcon: InkWell(
                onTap: () {
                  print("daal " + phoneController.text);
                  launch("tel://${phoneController.text}");
                },
                child: Padding(
                  padding:
                      EdgeInsets.only(top: 10), // add padding to adjust icon
                  child: Icon(Icons.call),
                ),
              )),
          controller: phoneController,
          keyboardType: TextInputType.phone,
          onChanged: (val) {
            print('onSubmited $val');
            widget.onTextChanged(val, widget.item);
          },
        ),
      ],
    );
  }
}
