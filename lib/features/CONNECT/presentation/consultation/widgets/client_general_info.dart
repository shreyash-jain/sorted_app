import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/CONNECT/data/models/client_consultation_model.dart';

class ClientInfo extends StatelessWidget {
  final ClientConsultationModel consultation;

  const ClientInfo({Key key, this.consultation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
              color: Colors.grey,
            ),
            Row(
              children: [
                Icon(
                  MdiIcons.phone,
                  size: 16,
                  color: Colors.black45,
                ),
                SizedBox(width: 14),
                Gtheme.stext(consultation.phoneNumber.toString(),
                    size: GFontSize.S, weight: GFontWeight.N),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  MdiIcons.cake,
                  size: 16,
                  color: Colors.black45,
                ),
                SizedBox(width: 14),
                Gtheme.stext(consultation.age.toString() + " years old",
                    size: GFontSize.S, weight: GFontWeight.N),
              ],
            ),
            SizedBox(height: 14),
          ],
        )
      ],
    );
  }
}
