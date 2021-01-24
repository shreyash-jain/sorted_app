part of 'interest_bloc.dart';

abstract class UserInterestState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadedState extends UserInterestState {
  final List<UserTag> fitnessTags;
  final List<UserTag> fitnessChosenTags;
  final List<UserTag> mentalHealthTags;
  final List<UserTag> mentalHealthChosenTags;
  final List<UserTag> foodTags;
  final List<UserTag> foodChosenTags;
  final List<UserTag> productivityTags;
  final List<UserTag> productivityChosenTags;
  final List<UserTag> careerTags;
  final List<UserTag> careerChosenTags;
  final List<UserTag> familyTags;
  final List<UserTag> familyChosenTags;
  final List<UserTag> financeTags;
  final List<UserTag> financeChosenTags;
  LoadedState(
      this.fitnessTags,
      this.fitnessChosenTags,
      this.mentalHealthTags,
      this.mentalHealthChosenTags,
      this.foodTags,
      this.foodChosenTags,
      this.productivityTags,
      this.productivityChosenTags,
      this.careerTags,
      this.careerChosenTags,
      this.familyTags,
      this.familyChosenTags,
      this.financeTags,
      this.financeChosenTags);
  @override
  List<Object> get props => [
        fitnessTags,
        fitnessChosenTags,
        mentalHealthTags,
        mentalHealthChosenTags,
        foodTags,
        foodChosenTags,
        productivityTags,
        productivityChosenTags,
        careerTags,
        careerChosenTags,
        familyTags,
        familyChosenTags,
        financeTags,
        financeChosenTags
      ];
}

class LoadingState extends UserInterestState {}
