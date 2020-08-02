part of 'user_recommendation_bloc.dart';
abstract class UserRecommendationState extends Equatable {
  const UserRecommendationState();
}
class UserRecommendationInitial extends UserRecommendationState {
  @override
  List<Object> get props => [];
}
