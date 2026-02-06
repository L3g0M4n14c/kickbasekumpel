// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  String get i => throw _privateConstructorUsedError;
  String get n => throw _privateConstructorUsedError;
  String get tn => throw _privateConstructorUsedError;
  String get em => throw _privateConstructorUsedError;
  int get b => throw _privateConstructorUsedError;
  int get tv => throw _privateConstructorUsedError;
  int get p => throw _privateConstructorUsedError;
  int get pl => throw _privateConstructorUsedError;
  int get f => throw _privateConstructorUsedError;

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call({
    String i,
    String n,
    String tn,
    String em,
    int b,
    int tv,
    int p,
    int pl,
    int f,
  });
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? i = null,
    Object? n = null,
    Object? tn = null,
    Object? em = null,
    Object? b = null,
    Object? tv = null,
    Object? p = null,
    Object? pl = null,
    Object? f = null,
  }) {
    return _then(
      _value.copyWith(
            i: null == i
                ? _value.i
                : i // ignore: cast_nullable_to_non_nullable
                      as String,
            n: null == n
                ? _value.n
                : n // ignore: cast_nullable_to_non_nullable
                      as String,
            tn: null == tn
                ? _value.tn
                : tn // ignore: cast_nullable_to_non_nullable
                      as String,
            em: null == em
                ? _value.em
                : em // ignore: cast_nullable_to_non_nullable
                      as String,
            b: null == b
                ? _value.b
                : b // ignore: cast_nullable_to_non_nullable
                      as int,
            tv: null == tv
                ? _value.tv
                : tv // ignore: cast_nullable_to_non_nullable
                      as int,
            p: null == p
                ? _value.p
                : p // ignore: cast_nullable_to_non_nullable
                      as int,
            pl: null == pl
                ? _value.pl
                : pl // ignore: cast_nullable_to_non_nullable
                      as int,
            f: null == f
                ? _value.f
                : f // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserImplCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$UserImplCopyWith(
    _$UserImpl value,
    $Res Function(_$UserImpl) then,
  ) = __$$UserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String i,
    String n,
    String tn,
    String em,
    int b,
    int tv,
    int p,
    int pl,
    int f,
  });
}

/// @nodoc
class __$$UserImplCopyWithImpl<$Res>
    extends _$UserCopyWithImpl<$Res, _$UserImpl>
    implements _$$UserImplCopyWith<$Res> {
  __$$UserImplCopyWithImpl(_$UserImpl _value, $Res Function(_$UserImpl) _then)
    : super(_value, _then);

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? i = null,
    Object? n = null,
    Object? tn = null,
    Object? em = null,
    Object? b = null,
    Object? tv = null,
    Object? p = null,
    Object? pl = null,
    Object? f = null,
  }) {
    return _then(
      _$UserImpl(
        i: null == i
            ? _value.i
            : i // ignore: cast_nullable_to_non_nullable
                  as String,
        n: null == n
            ? _value.n
            : n // ignore: cast_nullable_to_non_nullable
                  as String,
        tn: null == tn
            ? _value.tn
            : tn // ignore: cast_nullable_to_non_nullable
                  as String,
        em: null == em
            ? _value.em
            : em // ignore: cast_nullable_to_non_nullable
                  as String,
        b: null == b
            ? _value.b
            : b // ignore: cast_nullable_to_non_nullable
                  as int,
        tv: null == tv
            ? _value.tv
            : tv // ignore: cast_nullable_to_non_nullable
                  as int,
        p: null == p
            ? _value.p
            : p // ignore: cast_nullable_to_non_nullable
                  as int,
        pl: null == pl
            ? _value.pl
            : pl // ignore: cast_nullable_to_non_nullable
                  as int,
        f: null == f
            ? _value.f
            : f // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserImpl implements _User {
  const _$UserImpl({
    required this.i,
    required this.n,
    required this.tn,
    required this.em,
    required this.b,
    required this.tv,
    required this.p,
    required this.pl,
    required this.f,
  });

  factory _$UserImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserImplFromJson(json);

  @override
  final String i;
  @override
  final String n;
  @override
  final String tn;
  @override
  final String em;
  @override
  final int b;
  @override
  final int tv;
  @override
  final int p;
  @override
  final int pl;
  @override
  final int f;

  @override
  String toString() {
    return 'User(i: $i, n: $n, tn: $tn, em: $em, b: $b, tv: $tv, p: $p, pl: $pl, f: $f)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.i, i) || other.i == i) &&
            (identical(other.n, n) || other.n == n) &&
            (identical(other.tn, tn) || other.tn == tn) &&
            (identical(other.em, em) || other.em == em) &&
            (identical(other.b, b) || other.b == b) &&
            (identical(other.tv, tv) || other.tv == tv) &&
            (identical(other.p, p) || other.p == p) &&
            (identical(other.pl, pl) || other.pl == pl) &&
            (identical(other.f, f) || other.f == f));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, i, n, tn, em, b, tv, p, pl, f);

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      __$$UserImplCopyWithImpl<_$UserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserImplToJson(this);
  }
}

abstract class _User implements User {
  const factory _User({
    required final String i,
    required final String n,
    required final String tn,
    required final String em,
    required final int b,
    required final int tv,
    required final int p,
    required final int pl,
    required final int f,
  }) = _$UserImpl;

  factory _User.fromJson(Map<String, dynamic> json) = _$UserImpl.fromJson;

  @override
  String get i;
  @override
  String get n;
  @override
  String get tn;
  @override
  String get em;
  @override
  int get b;
  @override
  int get tv;
  @override
  int get p;
  @override
  int get pl;
  @override
  int get f;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) {
  return _LoginRequest.fromJson(json);
}

/// @nodoc
mixin _$LoginRequest {
  String get em => throw _privateConstructorUsedError;
  String get pass => throw _privateConstructorUsedError;
  bool get loy => throw _privateConstructorUsedError;
  Map<String, String> get rep => throw _privateConstructorUsedError;

  /// Serializes this LoginRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoginRequestCopyWith<LoginRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginRequestCopyWith<$Res> {
  factory $LoginRequestCopyWith(
    LoginRequest value,
    $Res Function(LoginRequest) then,
  ) = _$LoginRequestCopyWithImpl<$Res, LoginRequest>;
  @useResult
  $Res call({String em, String pass, bool loy, Map<String, String> rep});
}

/// @nodoc
class _$LoginRequestCopyWithImpl<$Res, $Val extends LoginRequest>
    implements $LoginRequestCopyWith<$Res> {
  _$LoginRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? em = null,
    Object? pass = null,
    Object? loy = null,
    Object? rep = null,
  }) {
    return _then(
      _value.copyWith(
            em: null == em
                ? _value.em
                : em // ignore: cast_nullable_to_non_nullable
                      as String,
            pass: null == pass
                ? _value.pass
                : pass // ignore: cast_nullable_to_non_nullable
                      as String,
            loy: null == loy
                ? _value.loy
                : loy // ignore: cast_nullable_to_non_nullable
                      as bool,
            rep: null == rep
                ? _value.rep
                : rep // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LoginRequestImplCopyWith<$Res>
    implements $LoginRequestCopyWith<$Res> {
  factory _$$LoginRequestImplCopyWith(
    _$LoginRequestImpl value,
    $Res Function(_$LoginRequestImpl) then,
  ) = __$$LoginRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String em, String pass, bool loy, Map<String, String> rep});
}

/// @nodoc
class __$$LoginRequestImplCopyWithImpl<$Res>
    extends _$LoginRequestCopyWithImpl<$Res, _$LoginRequestImpl>
    implements _$$LoginRequestImplCopyWith<$Res> {
  __$$LoginRequestImplCopyWithImpl(
    _$LoginRequestImpl _value,
    $Res Function(_$LoginRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? em = null,
    Object? pass = null,
    Object? loy = null,
    Object? rep = null,
  }) {
    return _then(
      _$LoginRequestImpl(
        em: null == em
            ? _value.em
            : em // ignore: cast_nullable_to_non_nullable
                  as String,
        pass: null == pass
            ? _value.pass
            : pass // ignore: cast_nullable_to_non_nullable
                  as String,
        loy: null == loy
            ? _value.loy
            : loy // ignore: cast_nullable_to_non_nullable
                  as bool,
        rep: null == rep
            ? _value._rep
            : rep // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LoginRequestImpl implements _LoginRequest {
  const _$LoginRequestImpl({
    required this.em,
    required this.pass,
    this.loy = false,
    final Map<String, String> rep = const {},
  }) : _rep = rep;

  factory _$LoginRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoginRequestImplFromJson(json);

  @override
  final String em;
  @override
  final String pass;
  @override
  @JsonKey()
  final bool loy;
  final Map<String, String> _rep;
  @override
  @JsonKey()
  Map<String, String> get rep {
    if (_rep is EqualUnmodifiableMapView) return _rep;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_rep);
  }

  @override
  String toString() {
    return 'LoginRequest(em: $em, pass: $pass, loy: $loy, rep: $rep)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginRequestImpl &&
            (identical(other.em, em) || other.em == em) &&
            (identical(other.pass, pass) || other.pass == pass) &&
            (identical(other.loy, loy) || other.loy == loy) &&
            const DeepCollectionEquality().equals(other._rep, _rep));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    em,
    pass,
    loy,
    const DeepCollectionEquality().hash(_rep),
  );

  /// Create a copy of LoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginRequestImplCopyWith<_$LoginRequestImpl> get copyWith =>
      __$$LoginRequestImplCopyWithImpl<_$LoginRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginRequestImplToJson(this);
  }
}

abstract class _LoginRequest implements LoginRequest {
  const factory _LoginRequest({
    required final String em,
    required final String pass,
    final bool loy,
    final Map<String, String> rep,
  }) = _$LoginRequestImpl;

  factory _LoginRequest.fromJson(Map<String, dynamic> json) =
      _$LoginRequestImpl.fromJson;

  @override
  String get em;
  @override
  String get pass;
  @override
  bool get loy;
  @override
  Map<String, String> get rep;

  /// Create a copy of LoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginRequestImplCopyWith<_$LoginRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) {
  return _LoginResponse.fromJson(json);
}

/// @nodoc
mixin _$LoginResponse {
  String get tkn => throw _privateConstructorUsedError;
  User? get user => throw _privateConstructorUsedError;
  List<dynamic>? get leagues => throw _privateConstructorUsedError;
  String? get userId => throw _privateConstructorUsedError;

  /// Serializes this LoginResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoginResponseCopyWith<LoginResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginResponseCopyWith<$Res> {
  factory $LoginResponseCopyWith(
    LoginResponse value,
    $Res Function(LoginResponse) then,
  ) = _$LoginResponseCopyWithImpl<$Res, LoginResponse>;
  @useResult
  $Res call({String tkn, User? user, List<dynamic>? leagues, String? userId});

  $UserCopyWith<$Res>? get user;
}

/// @nodoc
class _$LoginResponseCopyWithImpl<$Res, $Val extends LoginResponse>
    implements $LoginResponseCopyWith<$Res> {
  _$LoginResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tkn = null,
    Object? user = freezed,
    Object? leagues = freezed,
    Object? userId = freezed,
  }) {
    return _then(
      _value.copyWith(
            tkn: null == tkn
                ? _value.tkn
                : tkn // ignore: cast_nullable_to_non_nullable
                      as String,
            user: freezed == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as User?,
            leagues: freezed == leagues
                ? _value.leagues
                : leagues // ignore: cast_nullable_to_non_nullable
                      as List<dynamic>?,
            userId: freezed == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of LoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LoginResponseImplCopyWith<$Res>
    implements $LoginResponseCopyWith<$Res> {
  factory _$$LoginResponseImplCopyWith(
    _$LoginResponseImpl value,
    $Res Function(_$LoginResponseImpl) then,
  ) = __$$LoginResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String tkn, User? user, List<dynamic>? leagues, String? userId});

  @override
  $UserCopyWith<$Res>? get user;
}

/// @nodoc
class __$$LoginResponseImplCopyWithImpl<$Res>
    extends _$LoginResponseCopyWithImpl<$Res, _$LoginResponseImpl>
    implements _$$LoginResponseImplCopyWith<$Res> {
  __$$LoginResponseImplCopyWithImpl(
    _$LoginResponseImpl _value,
    $Res Function(_$LoginResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tkn = null,
    Object? user = freezed,
    Object? leagues = freezed,
    Object? userId = freezed,
  }) {
    return _then(
      _$LoginResponseImpl(
        tkn: null == tkn
            ? _value.tkn
            : tkn // ignore: cast_nullable_to_non_nullable
                  as String,
        user: freezed == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as User?,
        leagues: freezed == leagues
            ? _value._leagues
            : leagues // ignore: cast_nullable_to_non_nullable
                  as List<dynamic>?,
        userId: freezed == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LoginResponseImpl implements _LoginResponse {
  const _$LoginResponseImpl({
    required this.tkn,
    this.user,
    final List<dynamic>? leagues,
    this.userId,
  }) : _leagues = leagues;

  factory _$LoginResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoginResponseImplFromJson(json);

  @override
  final String tkn;
  @override
  final User? user;
  final List<dynamic>? _leagues;
  @override
  List<dynamic>? get leagues {
    final value = _leagues;
    if (value == null) return null;
    if (_leagues is EqualUnmodifiableListView) return _leagues;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? userId;

  @override
  String toString() {
    return 'LoginResponse(tkn: $tkn, user: $user, leagues: $leagues, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginResponseImpl &&
            (identical(other.tkn, tkn) || other.tkn == tkn) &&
            (identical(other.user, user) || other.user == user) &&
            const DeepCollectionEquality().equals(other._leagues, _leagues) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    tkn,
    user,
    const DeepCollectionEquality().hash(_leagues),
    userId,
  );

  /// Create a copy of LoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginResponseImplCopyWith<_$LoginResponseImpl> get copyWith =>
      __$$LoginResponseImplCopyWithImpl<_$LoginResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginResponseImplToJson(this);
  }
}

abstract class _LoginResponse implements LoginResponse {
  const factory _LoginResponse({
    required final String tkn,
    final User? user,
    final List<dynamic>? leagues,
    final String? userId,
  }) = _$LoginResponseImpl;

  factory _LoginResponse.fromJson(Map<String, dynamic> json) =
      _$LoginResponseImpl.fromJson;

  @override
  String get tkn;
  @override
  User? get user;
  @override
  List<dynamic>? get leagues;
  @override
  String? get userId;

  /// Create a copy of LoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginResponseImplCopyWith<_$LoginResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
