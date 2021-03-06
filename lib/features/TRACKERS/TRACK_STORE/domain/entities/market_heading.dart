import 'package:equatable/equatable.dart';

import 'track.dart';

class MarketHeading extends Equatable {
  int id;
  String icon_url;
  String name;
  String image_url;
  List<Track> tracksDetail;
  MarketHeading({
    this.id = 0,
    this.icon_url = '',
    this.name = '',
    this.image_url = '',
    this.tracksDetail = const [],
  });

  @override
  List<Object> get props {
    return [
      id,
      icon_url,
      name,
      image_url,
      tracksDetail,
    ];
  }
}
