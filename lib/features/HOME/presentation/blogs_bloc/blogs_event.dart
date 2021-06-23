part of 'blogs_bloc.dart';

abstract class BlogEvent extends Equatable {
  const BlogEvent();
}

class LoadBlogs extends BlogEvent {
  @override
  List<Object> get props => [];
}

class LoadTextBox extends BlogEvent {
  final BlogModel blog;
  LoadTextBox(this.blog);
  @override
  List<Object> get props => [blog];
}
