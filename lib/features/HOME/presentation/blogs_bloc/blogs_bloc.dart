import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/features/HOME/data/models/blog_textbox.dart';
import 'package:sorted/features/HOME/data/models/blogs.dart';
import 'package:sorted/features/HOME/domain/repositories/home_repository.dart';
part 'blogs_event.dart';
part 'blogs_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final HomeRepository repository;
  BlogBloc(this.repository) : super(BlogInitial());

  @override
  Stream<BlogState> mapEventToState(
    BlogEvent event,
  ) async* {
    if (event is LoadBlogs) {
      Failure failure;
      List<BlogModel> blogs = [];

      var blogsOrError = await repository.getBlogs(8);

      blogsOrError.fold((l) => failure = l, (r) {
        blogs = r;
      });

      if (failure == null)
        yield BlogLoaded(blogs);
      else
        yield BlogError(Failure.mapToString(failure));
    } else if (event is LoadTextBox) {
      BlogModel blog = event.blog;
      Failure failure;
      List<BlogTextboxModel> textboxes = [];
      var blogOrError = await repository.getTextBoxesOfBlog(blog.id);
      print("tbxes" + textboxes.length.toString());

      blogOrError.fold((l) => failure = l, (r) {
        textboxes = r;
      });
      if (failure == null)
        yield BlogTextBoxesLoaded(textboxes, blog);
      else
        yield BlogError(Failure.mapToString(failure));
    }
  }
}
