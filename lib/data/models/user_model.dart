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
  const factory LoginResponse({
    required String tkn,
    User? user,
    List<dynamic>? leagues,
    String? userId,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}
