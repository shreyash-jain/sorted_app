part of 'blogs_bloc.dart';

abstract class BlogState extends Equatable {
  const BlogState();
}

class BlogInitial extends BlogState {
  @override
  List<Object> get props => [];
}

class BlogLoaded extends BlogState {
  final List<BlogModel> blogs;

  BlogLoaded(this.blogs);

  @override
  List<Object> get props => [blogs];
}

class BlogTextBoxesLoaded extends BlogState {
  final List<BlogTextboxModel> textboxes;

  final BlogModel blog;

  BlogTextBoxesLoaded(this.textboxes, this.blog);

  List<Object> get props => [textboxes, blog];
}

class BlogError extends BlogState {
  final String message;

  BlogError(this.message);
  @override
  List<Object> get props => [message];
}
