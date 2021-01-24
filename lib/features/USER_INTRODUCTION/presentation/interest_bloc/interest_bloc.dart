import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/features/PROFILE/data/models/user_activity.dart';
import 'package:sorted/features/USER_INTRODUCTION/data/models/user_tag.dart';
import 'package:sorted/features/USER_INTRODUCTION/domain/repositories/user_intro_repository.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/flow_bloc/flow_bloc.dart';
part 'interest_event.dart';
part 'interest_state.dart';

class UserInterestBloc extends Bloc<UserInterestEvent, UserInterestState> {
  UserInterestBloc({@required this.repository, @required this.flowBloc})
      : super(
          LoadingState(),
        );

  final UserIntroductionBloc flowBloc;
  final UserIntroductionRepository repository;

  List<UserTag> openedTags = [];

  @override
  Stream<UserInterestState> mapEventToState(
    UserInterestEvent event,
  ) async* {
    if (event is LoadInterest) {
      Failure failure;
      List<UserTag> fitnessTags = [];
      List<UserTag> fitnessChosenTags = [];
      List<UserTag> mentalHealthTags = [];
      List<UserTag> mentalHealthChosenTags = [];
      List<UserTag> foodTags = [];
      List<UserTag> foodChosenTags = [];
      List<UserTag> productivityTags = [];
      List<UserTag> productivityChosenTags = [];
      List<UserTag> careerTags = [];
      List<UserTag> careerChosenTags = [];
      List<UserTag> familyTags = [];
      List<UserTag> familyChosenTags = [];
      List<UserTag> financeTags = [];
      List<UserTag> financeChosenTags = [];
      yield LoadingState();

      await Future.wait([
        repository.getFitnessTags(),
        repository.getCareerTags(),
        repository.getFamilyTags(),
        repository.getFinanceTags(),
        repository.getFoodTags(),
        repository.getProductivityTags(),
        repository.getMentalHealthTags()
      ]).then((List responses) {
        responses[0].fold((l) {
          failure = l;
        }, (r) {
          fitnessTags = r;
        });
        print("Say hi!");
        responses[4].fold((l) {
          failure = l;
        }, (r) {
          foodTags = r;
        });
        print("Say hi!!");
        responses[6].fold((l) {
          failure = l;
        }, (r) {
          mentalHealthTags = r;
        });
        print("Say hi!!!");
        responses[2].fold((l) {
          failure = l;
        }, (r) {
          familyTags = r;
        });
        print("Say hi!!!!");
        responses[3].fold((l) {
          failure = l;
        }, (r) {
          financeTags = r;
        });
        print("Say hi!!!!");
        responses[5].fold((l) {
          failure = l;
        }, (r) {
          productivityTags = r;
        });
        print("Say hi!!!!");

        responses[1].fold((l) {
          failure = l;
        }, (r) {
          careerTags = r;
        });
        print("Say hi!!!!!");
      }).catchError((e) {
        print("not worked  " + e);
        failure = ServerFailure();
      });

      if (failure == null) {
        print("worked");
        yield LoadedState(
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
            financeChosenTags);
      } else {
        print("not worked");
      }
    }
    if (event is Add) {
      Failure failure;
      LoadedState prevState = (state as LoadedState);
      List<UserTag> fitnessTags = prevState.fitnessTags;
      List<UserTag> fitnessChosenTags = prevState.fitnessChosenTags;
      List<UserTag> mentalHealthTags = prevState.mentalHealthTags;
      List<UserTag> mentalHealthChosenTags = prevState.mentalHealthChosenTags;
      List<UserTag> foodTags = prevState.foodTags;
      List<UserTag> foodChosenTags = prevState.foodChosenTags;

      List<UserTag> productivityTags = prevState.productivityTags;

      List<UserTag> productivityChosenTags = prevState.productivityChosenTags;

      List<UserTag> careerTags = prevState.careerTags;

      List<UserTag> careerChosenTags = prevState.careerChosenTags;

      List<UserTag> familyTags = prevState.familyTags;

      List<UserTag> familyChosenTags = prevState.familyChosenTags;

      List<UserTag> financeTags = prevState.financeTags;

      List<UserTag> financeChosenTags = prevState.financeChosenTags;
      switch (event.type) {
        case 0:
          {
            int indexTag = fitnessTags.indexOf(event.tag);
            if (fitnessChosenTags.indexOf(event.tag) == -1) {
              fitnessChosenTags.add(event.tag);
            } else {
              print("come here 9");
              print("come here 9 " +
                  fitnessChosenTags.remove(event.tag).toString());
            }
            if (openedTags.indexOf(event.tag) == -1) {
              var moreTags =
                  await repository.getChildrenOfTag(event.tag, "Fitness");

              moreTags.fold((l) {
                print("come here 2");
                failure = l;
              }, (r) {
                print("come here 1.5");
                if (r.length > 0) {
                  print("come here");
                  fitnessTags.insertAll(indexTag + 1, r);
                }
              });
              print("come here 3");
              openedTags.add(event.tag);
            }
            break;
          }
        case 1:
          {
            int indexTag = mentalHealthTags.indexOf(event.tag);
            if (mentalHealthChosenTags
                    .where((element) => (element.id == event.tag.id))
                    .toList()
                    .length ==
                0) {
              mentalHealthChosenTags.add(event.tag);
            } else {
              print("come here 9");
              print("come here 9 " +
                  mentalHealthChosenTags.remove(event.tag).toString());
            }
            if (openedTags
                    .where((element) => (element.id == event.tag.id))
                    .toList()
                    .length ==
                0) {
              var moreTags =
                  await repository.getChildrenOfTag(event.tag, "Mental Health");

              moreTags.fold((l) {
                print("come here 2");
                failure = l;
              }, (r) {
                print("come here 1.5");
                if (r.length > 0) {
                  print("come here");
                  mentalHealthTags.insertAll(indexTag + 1, r);
                }
              });
              print("come here 3");
              openedTags.add(event.tag);
            }
            break;
          }
        case 2:
          {
            int indexTag = foodTags.indexOf(event.tag);
            if (foodChosenTags
                    .where((element) => (element.id == event.tag.id))
                    .toList()
                    .length ==
                0) {
              foodChosenTags.add(event.tag);
            } else {
              print("come here 9");
              print(
                  "come here 9 " + foodChosenTags.remove(event.tag).toString());
            }
            if (openedTags
                    .where((element) => (element.id == event.tag.id))
                    .toList()
                    .length ==
                0) {
              var moreTags = await repository.getChildrenOfTag(
                  event.tag, "Food and Nutrition");

              moreTags.fold((l) {
                print("come here 2");
                failure = l;
              }, (r) {
                print("come here 1.5");
                if (r.length > 0) {
                  print("come here");
                  foodTags.insertAll(indexTag + 1, r);
                }
              });
              print("come here 3");
              openedTags.add(event.tag);
            }
            break;
          }
        case 3:
          {
            int indexTag = productivityTags.indexOf(event.tag);
            if (productivityChosenTags
                    .where((element) => (element.id == event.tag.id))
                    .toList()
                    .length ==
                0) {
              productivityChosenTags.add(event.tag);
            } else {
              print("come here 9");
              print("come here 9 " +
                  productivityChosenTags.remove(event.tag).toString());
            }
            if (openedTags
                    .where((element) => (element.id == event.tag.id))
                    .toList()
                    .length ==
                0) {
              var moreTags =
                  await repository.getChildrenOfTag(event.tag, "Productivity");

              moreTags.fold((l) {
                print("come here 2");
                failure = l;
              }, (r) {
                print("come here 1.5");
                if (r.length > 0) {
                  print("come here");
                  productivityTags.insertAll(indexTag + 1, r);
                }
              });
              print("come here 3");
              openedTags.add(event.tag);
            }
            break;
          }
        case 4:
          {
            int indexTag = familyTags.indexOf(event.tag);
            if (familyChosenTags
                    .where((element) => (element.id == event.tag.id))
                    .toList()
                    .length ==
                0) {
              familyChosenTags.add(event.tag);
            } else {
              print("come here 9");
              print("come here 9 " +
                  familyChosenTags.remove(event.tag).toString());
            }
            if (openedTags
                    .where((element) => (element.id == event.tag.id))
                    .toList()
                    .length ==
                0) {
              var moreTags = await repository.getChildrenOfTag(
                  event.tag, "Family and Relationship");

              moreTags.fold((l) {
                print("come here 2");
                failure = l;
              }, (r) {
                print("come here 1.5");
                if (r.length > 0) {
                  print("come here");
                  familyTags.insertAll(indexTag + 1, r);
                }
              });
              print("come here 3");
              openedTags.add(event.tag);
            }
            break;
          }
        case 5:
          {
            int indexTag = careerTags.indexOf(event.tag);
            if (careerChosenTags
                    .where((element) => (element.id == event.tag.id))
                    .toList()
                    .length ==
                0) {
              careerChosenTags.add(event.tag);
            } else {
              print("come here 9");
              print("come here 9 " +
                  careerChosenTags.remove(event.tag).toString());
            }
            if (openedTags
                    .where((element) => (element.id == event.tag.id))
                    .toList()
                    .length ==
                0) {
              var moreTags =
                  await repository.getChildrenOfTag(event.tag, "Career");

              moreTags.fold((l) {
                print("come here 2");
                failure = l;
              }, (r) {
                print("come here 1.5");
                if (r.length > 0) {
                  print("come here");
                  careerTags.insertAll(indexTag + 1, r);
                }
              });
              print("come here 3");
              openedTags.add(event.tag);
            }
            break;
          }
        case 6:
          {
            int indexTag = financeTags.indexOf(event.tag);
            if (financeChosenTags
                    .where((element) => (element.id == event.tag.id))
                    .toList()
                    .length ==
                0) {
              financeChosenTags.add(event.tag);
            } else {
              print("come here 9");
              print("come here 9 " +
                  financeChosenTags.remove(event.tag).toString());
            }
            if (openedTags
                    .where((element) => (element.id == event.tag.id))
                    .toList()
                    .length ==
                0) {
              var moreTags = await repository.getChildrenOfTag(
                  event.tag, "Finance and Money");

              moreTags.fold((l) {
                print("come here 2");
                failure = l;
              }, (r) {
                print("come here 1.5");
                if (r.length > 0) {
                  print("come here");
                  financeTags.insertAll(indexTag + 1, r);
                }
              });
              print("come here 3");
              openedTags.add(event.tag);
            }
            break;
          }

          break;
        default:
      }
      print("come here 4");
      yield LoadingState();
      yield LoadedState(
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
          financeChosenTags);
    } else if (event is Remove) {}
  }

  @override
  Future<void> close() async {
    print("interest block");
    LoadedState oldState = (state as LoadedState);
    repository.saveUserInterests(
        oldState.fitnessChosenTags,
        oldState.mentalHealthChosenTags,
        oldState.foodChosenTags,
        oldState.productivityChosenTags,
        oldState.familyChosenTags,
        oldState.careerChosenTags,
        oldState.financeChosenTags);

    return super.close();
  }
}
