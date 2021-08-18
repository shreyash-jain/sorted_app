import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/widgets/image_placeholder_widget.dart';
import 'package:sorted/features/CONNECT/data/models/client_consultation_model.dart';

class ConsultationEnrolledClientTile extends StatelessWidget {
  final ClientConsultationModel consultation;
  final Function(ClientConsultationModel) onClickClient;
  const ConsultationEnrolledClientTile(
      {Key key, this.consultation, this.onClickClient})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onClickClient != null) {
          onClickClient(consultation);
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        padding: EdgeInsets.only(bottom: 0),
        width: Gparam.width - 1.05 * Gparam.widthPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (consultation.packageName != "")
                      Gtheme.stext(consultation.packageName ?? "package",
                          weight: GFontWeight.L, size: GFontSize.XS),
                    if (consultation.age != 0)
                      SizedBox(
                        height: 8,
                      ),
                    if (consultation.age != 0)
                      Gtheme.stext("Expert : " + consultation.coachName,
                          weight: GFontWeight.B, size: GFontSize.S),
                  ],
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.all(4),
                  margin: EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: Colors.grey.shade300, width: 1.5),
                      borderRadius: BorderRadius.circular(5)),
                  child: Gtheme.stext(" View Consultation ",
                      size: GFontSize.XXXS,
                      weight: GFontWeight.N,
                      color: GColors.B),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }
}
