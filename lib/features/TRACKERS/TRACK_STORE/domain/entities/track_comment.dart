import 'package:equatable/equatable.dart';

class TrackComment extends Equatable {
  int id;
  String user_name;
  String user_id;
  String user_icon;
  String comment;
  double sentiment_value;
  TrackComment({
    this.id,
    this.user_name,
    this.user_id,
    this.user_icon,
    this.comment,
    this.sentiment_value,
  });

  @override
  List<Object> get props {
    return [
      id,
      user_name,
      user_id,
      user_icon,
      comment,
      sentiment_value,
    ];
  }
}
