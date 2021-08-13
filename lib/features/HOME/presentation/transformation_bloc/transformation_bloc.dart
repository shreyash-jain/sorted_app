import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/features/HOME/data/models/blog_textbox.dart';
import 'package:sorted/features/HOME/data/models/blogs.dart';
import 'package:sorted/features/HOME/data/models/motivation/transformation.dart';
import 'package:sorted/features/HOME/data/models/recipes/tagged_recipe.dart';

import 'package:sorted/features/HOME/data/models/recipes/video_recipe.dart';
import 'package:sorted/features/HOME/domain/repositories/home_repository.dart';
part 'transformation_event.dart';
part 'transformation_state.dart';

class TransformationBloc
    extends Bloc<TransformationEvent, TransformationState> {
  final HomeRepository repository;
  TransformationBloc(this.repository) : super(TransformationInitial());

  @override
  Stream<TransformationState> mapEventToState(
    TransformationEvent event,
  ) async* {
    if (event is LoadTransformation) {
      Failure failure;
      TransformationModel trans;

      var transformationOrError = await repository.getTransformationStory();
      transformationOrError.fold((l) => failure = l, (r) => trans = r);

      if (failure == null && trans.id!=-1)
        yield HomePageTransformationLoaded(trans);
      else {
        yield TransformationError(Failure.mapToString(failure));
      }

      // if (failure == null)
      //   yield RecipeLoaded(blogs);
      // else
      //   yield RecipeError(Failure.mapToString(failure));
    }
  }
}
