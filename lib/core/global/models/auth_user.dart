import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// {@template user}
/// User model
///
/// [NativeUser.empty] represents an unauthenticated user.
/// {@endtemplate}
/// 
class NativeUser extends Equatable {
  /// {@macro user}
  const NativeUser({
    @required this.email,
    @required this.id,
    @required this.name,
    @required this.photo,
  })  : assert(email != null),
        assert(id != null);

  /// The current user's email address.
  final String email;

  /// The current user's id.
  final String id;

  /// The current user's name (display name).
  final String name;

  /// Url for the current user's photo.
  final String photo;

  /// Empty user which represents an unauthenticated user.
  static const empty = NativeUser(email: '', id: '', name: null, photo: null);

  @override
  List<Object> get props => [email, id, name, photo];
}