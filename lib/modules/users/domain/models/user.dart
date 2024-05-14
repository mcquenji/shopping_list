import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  factory User({
    /// The user's id.
    ///
    /// Must be unique.
    required String id,

    /// The user's name.
    ///
    /// This doesn't have to be the user's real name nor unique.
    required String name,

    /// The user's email.
    ///
    /// Must be unique.
    required String email,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
