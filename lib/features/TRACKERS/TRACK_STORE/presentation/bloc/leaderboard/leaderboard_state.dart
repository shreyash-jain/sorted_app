part of 'leaderboard_bloc.dart';

abstract class LeaderboardState extends Equatable {
  const LeaderboardState();

  @override
  List<Object> get props => [];
}

class LeaderboardInitial extends LeaderboardState {}

class GetLeaderboardDataLoadedState extends LeaderboardState {
  final List<Map<String, dynamic>> last7_data;
  final List<Map<String, dynamic>> last30_data;
  final List<Map<String, dynamic>> alltime_data;
    GetLeaderboardDataLoadedState({this.last30_data, this.alltime_data, this.last7_data,});
}

class GetLeaderboardDataLoadingState extends LeaderboardState {}

class GetLeaderboardDataFailedState extends LeaderboardState {}
