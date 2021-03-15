import 'package:equatable/equatable.dart';
import 'track.dart';

class MarketTab extends Equatable {
  int id;
  String name;
  List<int> tracks;
  MarketTab({
    this.id = 0,
    this.name = '',
    this.tracks = const [],
  });

  @override
  List<Object> get props {
    return [
      id,
      name,
      tracks,
    ];
  }
}
