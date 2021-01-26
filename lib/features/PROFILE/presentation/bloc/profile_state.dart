part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  @override
  List<Object> get props => [];
}

class ProfileLoaded extends ProfileState {
  final double bmi;
  final List<String> fitnessStrings;
  final List<String> mindfulStrings;
  final List<String> productivityStrings;
  final List<String> personalityStrings;
  final List<String> foodStrings;
  final double sleepScore;
  final double mentalHealthScore;
  final double productivityScore;
  final double vata;
  final double pitta;
  final double kapha;

  final String sleepString;

  ProfileLoaded({this.sleepString,
      this.bmi,
      this.fitnessStrings,
      this.mindfulStrings,
      this.productivityStrings,
      this.personalityStrings,
      this.foodStrings,
      this.sleepScore,
      this.mentalHealthScore,
      this.productivityScore,
      this.vata,
      this.pitta,
      this.kapha});

  @override
  List<Object> get props => [
        bmi,
        foodStrings,
        sleepScore,
        productivityScore,
        pitta,
        vata,
        kapha,
        mentalHealthScore,
        fitnessStrings,
        mindfulStrings,
        productivityStrings,
        personalityStrings,
        sleepString
      ];
}
