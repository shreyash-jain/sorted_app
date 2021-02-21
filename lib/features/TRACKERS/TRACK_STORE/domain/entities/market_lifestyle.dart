import 'package:equatable/equatable.dart';
import 'track.dart';

class MarketLifestyle extends Equatable {
  int id;
  String heading;
  String sub_heading;
  String description;
  String url;
  List<Track> tracks;
  MarketLifestyle({
    this.id = 0,
    this.heading = '',
    this.sub_heading = '',
    this.description = '',
    this.url = '',
    this.tracks = const [],
  });

  @override
  List<Object> get props {
    return [
      id,
      heading,
      sub_heading,
      description,
      url,
      tracks,
    ];
  }
}
