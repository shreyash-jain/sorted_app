import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/CONNECT/data/models/expert/expert_profile.dart';
import 'package:sorted/features/CONNECT/presentation/widgets/classroom_preview.dart';

class ExpertProfileWidget extends StatelessWidget {
  final ExpertProfileModel profile;
  const ExpertProfileWidget({Key key, this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: (profile.coverImage != null && profile.coverImage != '')
              ? 200
              : 86,
          padding: EdgeInsets.all(8),
          child: Stack(
            children: [
              if (profile.coverImage != null && profile.coverImage != '')
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    width: Gparam.width,
                    height: 170,
                    fit: BoxFit.cover,
                    imageUrl: profile.coverImage,
                    placeholder: (context, url) => ImagePlaceholderWidget(),
                    errorWidget: (context, url, error) => Icon(
                      Icons.error,
                      color: Colors.grey,
                    ),
                  ),
                ),
              Positioned(
                bottom: 0,
                left: 20,
                child: InkWell(
                  onTap: () async {
                    // widget.profileBloc
                  },
                  child: Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white, width: 3)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: (profile.googleImage != null &&
                                  profile.googleImage != '')
                              ? profile.googleImage
                              : "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/Placeholders%2Fuser%20(4).png?alt=media&token=d52f13c6-d232-4513-87e4-2f331599ad22",
                          placeholder: (context, url) =>
                              ImagePlaceholderWidget(),
                          errorWidget: (context, url, error) => Icon(
                            Icons.error,
                            color: Colors.grey,
                          ),
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
        if (profile?.city != null && profile.city != '')
          SizedBox(
            height: 16,
          ),
        if (profile?.city != null && profile.city != '')
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Gparam.widthPadding),
            child: Row(
              children: [
                Icon(
                  MdiIcons.mapMarkerOutline,
                  size: 25,
                ),
                SizedBox(
                  width: 8,
                ),
                Gtheme.stext(profile.city,
                    size: GFontSize.S, weight: GFontWeight.N),
              ],
            ),
          ),
        if (profile?.experience != null && profile.experience != 0)
          SizedBox(
            height: 8,
          ),
        if (profile?.experience != null && profile.experience != 0)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Gparam.widthPadding),
            child: Row(
              children: [
                Icon(
                  MdiIcons.policeBadgeOutline,
                  size: 25,
                ),
                SizedBox(
                  width: 8,
                ),
                Gtheme.stext(
                    profile.experience.toString() + " years of experience",
                    size: GFontSize.S,
                    weight: GFontWeight.N),
              ],
            ),
          ),
        SizedBox(
          height: 12,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Gparam.widthPadding),
          child: Row(
            children: [
              Flexible(
                child: Gtheme.stext(profile.description,
                    size: GFontSize.XS, weight: GFontWeight.L),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
