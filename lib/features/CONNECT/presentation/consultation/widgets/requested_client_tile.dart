import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/CONNECT/data/models/client_consultation_model.dart';
import 'package:sorted/features/CONNECT/presentation/widgets/classroom_preview.dart';

class ConsultationRequestedClientTile extends StatelessWidget {
  final ClientConsultationModel consultation;
  final Function(ClientConsultationModel) onClickClient;
  const ConsultationRequestedClientTile(
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
                    Gtheme.stext(consultation.packageName ?? "package",
                        weight: GFontWeight.L, size: GFontSize.XXS),
                    SizedBox(
                      height: 4,
                    ),
                    if (consultation.age != 0)
                      SizedBox(
                        height: 8,
                      ),
                    Gtheme.stext("Expert : " + consultation.coachName,
                        weight: GFontWeight.B, size: GFontSize.S),
                  ],
                ),
                Spacer(),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            if (consultation.initialClientMessage != "")
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: RichText(
                    text: TextSpan(
                        text: 'Message from Client:  \n\n',
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Milliard",
                            fontSize: 16),
                        children: <TextSpan>[
                      TextSpan(
                          text: consultation.initialClientMessage,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ))
                    ])),
              ),
            SizedBox(
              height: 6,
            ),
          ],
        ),
      ),
    );
  }
}
