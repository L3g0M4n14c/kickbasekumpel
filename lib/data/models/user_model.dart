import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// User Model - Kickbase User/Manager
@freezed
class User with _$User {
  const factory User({
    required String i,
    required String n,
    required String tn,
    required String em,
    required int b,
    required int tv,
    required int p,
    required int pl,
    required int f,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

/// Login User - User data from login response (different format)
/// Maps from Kickbase API login response "u" field
@freezed
class LoginUser with _$LoginUser {
  const LoginUser._();

  const factory LoginUser({
    required String id,
    required String name,
    required String email,
    int? notifications,
    String? cover,
    int? flags,
    String? proExpiry,
    List<int>? perms,
    int? trd,
    String? sfb,
    String? efb,
    String? profile,
    String? uim,
    List<dynamic>? mfacp,
  }) = _LoginUser;

  factory LoginUser.fromJson(Map<String, dynamic> json) =>
      _$LoginUserFromJson(json);

  /// Convert LoginUser to User model
  User toUser() {
    return User(
      i: id,
      n: name,
      tn: '', // Team name not provided in login response
      em: email,
      b: 0, // Budget not provided in login response
      tv: 0, // Team value not provided in login response
      p: 0, // Points not provided in login response
      pl: 0, // Placement not provided in login response
      f: flags ?? 0,
    );
  }
}

/// Login Request
@freezed
class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    required String em,
    required String pass,
    @Default(false) bool loy,
    @Default({}) Map<String, String> rep,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}

/// Login Response
@freezed
class LoginResponse with _$LoginResponse {
  const LoginResponse._();

  const factory LoginResponse({
    required String tkn,
    @JsonKey(name: 'u') LoginUser? loginUser,
    @JsonKey(name: 'srvl') List<dynamic>? leagues,
    String? userId,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  /// Get User from LoginResponse
  User? get user => loginUser?.toUser();
}
