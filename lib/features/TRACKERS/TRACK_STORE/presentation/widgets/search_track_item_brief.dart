import 'package:flutter/material.dart';
import '../../domain/entities/track_brief.dart';
import '../../../../../core/global/constants/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/track_store_search/track_store_search_bloc.dart';

class SearchTrackItemBrief extends StatelessWidget {
  final TrackBrief trackBrief;
  const SearchTrackItemBrief({this.trackBrief});

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.symmetric(
      //   horizontal: Gparam.widthPadding * 0.8,
      //   vertical: Gparam.heightPadding * 0.4,
      // ),
      padding: EdgeInsets.symmetric(
        horizontal: Gparam.widthPadding / 2,
        vertical: Gparam.heightPadding / 2,
      ),
      child: ListTile(
        leading: SizedBox(
          height: 50,
          width: 50,
          child: CachedNetworkImage(
            imageUrl: trackBrief?.track_icon ?? "",
            errorWidget: (_, __, ___) => Icon(Icons.error),
          ),
        ),
        title: Text(
          trackBrief?.track_name ?? '',
          style: TextStyle(
            fontFamily: 'Montserrat',
            color: Theme.of(context).highlightColor,
            fontSize: Gparam.textSmaller,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: () {
          BlocProvider.of<TrackStoreSearchBloc>(context).add(
            AddSuggestionEvent(
              id: trackBrief.track_id,
              name: trackBrief.track_name,
              icon: trackBrief.track_icon,
            ),
          );
          BlocProvider.of<TrackStoreSearchBloc>(context).add(
            GetTrackDetailsEvent(track_id: trackBrief.track_id),
          );
        },
      ),
    );
  }
}
