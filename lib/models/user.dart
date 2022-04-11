import 'package:equatable/equatable.dart';

/// {@template user}
/// User model
///
/// [UserModel.empty] represents an unauthenticated user.
/// {@endtemplate}
class UserModel extends Equatable {
  /// {@macro user}
  const UserModel({
    this.email,
    required this.id,
    required this.displayName,
    required this.imageUrl,
  });

  /// The current user's email address.
  final String? email;

  /// The current user's id.
  final String id;

  /// The current user's name (display name).
  final String displayName;

  /// Url for the current user's photo.
  final String imageUrl;

  /// Empty user which represents an unauthenticated user.
  static const empty = UserModel(
    // email: '',
    id: '',
    displayName: '',
    imageUrl: '',
  );

  @override
  List<Object?> get props => [
        email,
        id,
        displayName,
        imageUrl,
      ];
}
