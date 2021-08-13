import 'package:equatable/equatable.dart';

class TrackBrief extends Equatable {
  int track_id;
  String track_name;
  String track_icon;

  TrackBrief({
    this.track_id,
    this.track_name,
    this.track_icon,
  });
  @override
  List<Object> get props {
    return [
      track_id,
      track_name,
      track_icon,
    ];
  }
}
