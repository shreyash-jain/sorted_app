import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/FILES/data/models/block_table_item.dart';
import 'package:url_launcher/url_launcher.dart';

class TableLinkWidget extends StatefulWidget {
  final TableItemBlock item;
  final Function(String text, TableItemBlock item) onTextChanged;
  TableLinkWidget(this.item, this.onTextChanged);

  @override
  _TableLinkCard createState() => _TableLinkCard();
}

class _TableLinkCard extends State<TableLinkWidget> {
  TextEditingController linkController;
  bool isLaunchable = false;
  @override
  void initState() {
    linkController = TextEditingController(text: widget.item.value);
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
              hintText: "Link url",
              suffixIcon: isLaunchable
                  ? InkWell(
                      onTap: () async {
                        print("jjs" + linkController.text);
                        if (await canLaunch(linkController.text))
                          await launch(linkController.text);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 10), // add padding to adjust icon
                        child: Icon(Icons.open_in_browser),
                      ),
                    )
                  : null),
          controller: linkController,
          keyboardType: TextInputType.url,
          onChanged: (val) async {
            print('onSubmited $val');
            widget.onTextChanged(val, widget.item);
            bool isL = await canLaunch(val);
            setState(() {
              if (isL)
                isLaunchable = true;
              else
                isLaunchable = false;
              print(isLaunchable);
            });
          },
        ),
      ],
    );
  }
}
