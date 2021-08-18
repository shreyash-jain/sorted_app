import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/CONNECT/data/models/client_consultation_model.dart';
import 'package:sorted/features/CONNECT/presentation/widgets/classroom_preview.dart';

class ClientPreview extends StatelessWidget {
  final ClientConsultationModel consultation;

  const ClientPreview({Key key, this.consultation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gtheme.stext("Trainer", size: GFontSize.XS, weight: GFontWeight.L),
            SizedBox(height: 8),
            Gtheme.stext(consultation.coachName, weight: GFontWeight.B1),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  MdiIcons.targetVariant,
                  size: 16,
                  color: Colors.black45,
                ),
                SizedBox(width: 4),
                Gtheme.stext(consultation.packageName,
                    size: GFontSize.XXS, weight: GFontWeight.L),
              ],
            ),
          ],
        )
      ],
    );
  }
}
