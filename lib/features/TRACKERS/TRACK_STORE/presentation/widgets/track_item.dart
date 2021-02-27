import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sorted/features/TRACKERS/TRACK_STORE/presentation/pages/single_track_page.dart';
import '../../domain/entities/track.dart';
import '../../domain/entities/market_heading.dart';
import '../../../../../core/global/constants/constants.dart';

class TrackItem extends StatelessWidget {
  final Track track;
  final MarketHeading marketHeading;
  const TrackItem({@required this.track, @required this.marketHeading});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => SingleTrackPage(
              track: track,
              marketHeading: marketHeading,
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Hero(
            tag: "track-icon-${marketHeading.id}-${track.id}",
            child: Container(
              margin: EdgeInsets.all(Gparam.widthPadding / 2),
              // padding: EdgeInsets.all(8),
              width: Gparam.height * 0.2,
              height: Gparam.height * 0.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).backgroundColor,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: CachedNetworkImageProvider(
                    track.icon,
                  ),
                ),
              ),
            ),
          ),
          Hero(
            tag: "track-name-${marketHeading.id}-${track.id}",
            child: Text(
              track.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:sorted/features/TRACKERS/TRACK_STORE/presentation/pages/single_track_page.dart';
// import '../../domain/entities/track.dart';
// import '../../domain/entities/market_heading.dart';
// import '../../../../../core/global/constants/constants.dart';
// import 'package:animations/animations.dart';

// const double _fabDimension = 56.0;

// class TrackItem extends StatelessWidget {
//   final Track track;
//   final MarketHeading marketHeading;
//   const TrackItem({@required this.track, @required this.marketHeading});
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       // onTap: () {
//       //   Navigator.of(context).push(
//       //     MaterialPageRoute(
//       //       builder: (_) => SingleTrackPage(
//       //         track: track,
//       //         marketHeading: marketHeading,
//       //       ),
//       //     ),
//       //   );
//       // },
//       child: OpenContainer(
//         transitionType: ContainerTransitionType.fade,
//         openBuilder: (BuildContext context, VoidCallback _) {
//           return SingleTrackPage(
//             track: track,
//             marketHeading: marketHeading,
//           );
//         },
//         // closedElevation: 6.0,
//         // closedShape: const RoundedRectangleBorder(
//         //   borderRadius: BorderRadius.all(
//         //     Radius.circular(_fabDimension / 2),
//         //   ),
//         // ),
//         // closedColor: Theme.of(context).colorScheme.secondary,
//         closedBuilder: (BuildContext context, VoidCallback openContainer) {
//           return TrackItemWidget(
//             track: track,
//           );
//         },
//       ),
//     );
//   }
// }

// class TrackItemWidget extends StatelessWidget {
//   const TrackItemWidget({
//     Key key,
//     @required this.track,
//   }) : super(key: key);

//   final Track track;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Container(
//           margin: EdgeInsets.all(Gparam.widthPadding / 2),
//           // padding: EdgeInsets.all(8),
//           width: Gparam.height * 0.2,
//           height: Gparam.height * 0.2,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             color: Theme.of(context).backgroundColor,
//             image: DecorationImage(
//               fit: BoxFit.fill,
//               image: CachedNetworkImageProvider(
//                 track.icon,
//               ),
//             ),
//           ),
//         ),
//         Text(
//           track.name,
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ],
//     );
//   }
// }
