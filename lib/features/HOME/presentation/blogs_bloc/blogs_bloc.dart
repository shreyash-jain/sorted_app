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

      var blogOrError = await repository.getBlogFromId(1613913443938);

      blogOrError.fold((l) => failure = l, (r) {
        if (r.id != -1) blogs.add(r);
      });

      blogOrError = await repository.getBlogFromId(1613878831741);

      blogOrError.fold((l) => failure = l, (r) {
        if (r.id != -1) blogs.add(r);
      });
      blogOrError = await repository.getBlogFromId(1619634783265);

      blogOrError.fold((l) => failure = l, (r) {
        if (r.id != -1) blogs.add(r);
      });
      blogOrError = await repository.getBlogFromId(1618944771013);

      blogOrError.fold((l) => failure = l, (r) {
        if (r.id != -1) blogs.add(r);
      });
      blogOrError = await repository.getBlogFromId(1618941392236);

      blogOrError.fold((l) => failure = l, (r) {
        if (r.id != -1) blogs.add(r);
      });
      blogOrError = await repository.getBlogFromId(1619293175206);

      blogOrError.fold((l) => failure = l, (r) {
        if (r.id != -1) blogs.add(r);
      });

      blogOrError = await repository.getBlogFromId(1619633202314);

      blogOrError.fold((l) => failure = l, (r) {
        if (r.id != -1) blogs.add(r);
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
