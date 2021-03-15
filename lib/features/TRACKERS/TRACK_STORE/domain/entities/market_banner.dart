import 'package:equatable/equatable.dart';
import './track.dart';

class MarketBanner extends Equatable {
  int id;
  int action;
  String heading;
  String sub_heading;
  String image_url;
  String text_color;
  List<Track> tracksDetail;
  MarketBanner({
    this.id = 0,
    this.action = 0,
    this.heading = '',
    this.sub_heading = '',
    this.image_url = '',
    this.text_color = '',
    this.tracksDetail = const [],
  });

  @override
  List<Object> get props => [
        id,
        action,
        heading,
        sub_heading,
        image_url,
        tracksDetail,
        text_color,
      ];
}
