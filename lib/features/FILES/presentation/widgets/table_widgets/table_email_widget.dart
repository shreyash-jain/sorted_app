import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/FILES/data/models/block_table_item.dart';
import 'package:url_launcher/url_launcher.dart';

class TableEmailWidget extends StatefulWidget {
  final TableItemBlock item;
  final Function(String text, TableItemBlock item) onTextChanged;
  TableEmailWidget(this.item, this.onTextChanged);

  @override
  _TableEmailCard createState() => _TableEmailCard();
}

class _TableEmailCard extends State<TableEmailWidget> {
  TextEditingController emailController;
  @override
  void initState() {
    emailController = TextEditingController(text: widget.item.value);
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
              hintText: "Email",
              suffixIcon: InkWell(
                onTap: () async {
                  final Uri _emailLaunchUri = Uri(
                      scheme: 'mailto',
                      path: emailController.text,
                      queryParameters: {'subject': 'Regarding ...'});
                  launch(_emailLaunchUri.toString());
                },
                child: Padding(
                  padding:
                      EdgeInsets.only(top: 10), // add padding to adjust icon
                  child: Icon(Icons.email),
                ),
              )),
          
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          onChanged: (val) {
            print('onSubmited $val');
            widget.onTextChanged(val, widget.item);
          },
        ),
      ],
    );
  }
}
