// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AuthState {
  UserRole get selectedRole => throw _privateConstructorUsedError;
  bool get isAuthenticated => throw _privateConstructorUsedError;
  String get workContext => throw _privateConstructorUsedError;
  String? get selectedPartner => throw _privateConstructorUsedError;
  IconData? get partnerIcon => throw _privateConstructorUsedError;
  String? get partnerType => throw _privateConstructorUsedError;

  /// Tracks the agent login flow lifecycle so the UI can show
  /// loading, surface failures, and prevent duplicate submissions.
  AuthLoginStatus get loginStatus => throw _privateConstructorUsedError;

  /// Holds the latest error message for display.
  String? get loginErrorMessage => throw _privateConstructorUsedError;

  /// Active session details. Populated after a successful login and
  /// also hydrated from local storage when the app starts.
  SessionEntity? get session => throw _privateConstructorUsedError;

  /// True when the most recent successful login signalled that the
  /// agent must change their password before a normal session is
  /// issued. The login screen uses this to route the agent to the
  /// change-password flow instead of the role dashboard.
  ///
  /// Note: this flag is intentionally duplicated at the state level
  /// (it's also available on [session.mustChangePassword]) so the
  /// LoginScreen listener can branch on it without having to read
  /// the optional [session] field.
  bool get mustChangePassword => throw _privateConstructorUsedError;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthStateCopyWith<AuthState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthStateCopyWith<$Res> {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) then) =
      _$AuthStateCopyWithImpl<$Res, AuthState>;
  @useResult
  $Res call({
    UserRole selectedRole,
    bool isAuthenticated,
    String workContext,
    String? selectedPartner,
    IconData? partnerIcon,
    String? partnerType,
    AuthLoginStatus loginStatus,
    String? loginErrorMessage,
    SessionEntity? session,
    bool mustChangePassword,
  });
}

/// @nodoc
class _$AuthStateCopyWithImpl<$Res, $Val extends AuthState>
    implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedRole = null,
    Object? isAuthenticated = null,
    Object? workContext = null,
    Object? selectedPartner = freezed,
    Object? partnerIcon = freezed,
    Object? partnerType = freezed,
    Object? loginStatus = null,
    Object? loginErrorMessage = freezed,
    Object? session = freezed,
    Object? mustChangePassword = null,
  }) {
    return _then(
      _value.copyWith(
            selectedRole: null == selectedRole
                ? _value.selectedRole
                : selectedRole // ignore: cast_nullable_to_non_nullable
                      as UserRole,
            isAuthenticated: null == isAuthenticated
                ? _value.isAuthenticated
                : isAuthenticated // ignore: cast_nullable_to_non_nullable
                      as bool,
            workContext: null == workContext
                ? _value.workContext
                : workContext // ignore: cast_nullable_to_non_nullable
                      as String,
            selectedPartner: freezed == selectedPartner
                ? _value.selectedPartner
                : selectedPartner // ignore: cast_nullable_to_non_nullable
                      as String?,
            partnerIcon: freezed == partnerIcon
                ? _value.partnerIcon
                : partnerIcon // ignore: cast_nullable_to_non_nullable
                      as IconData?,
            partnerType: freezed == partnerType
                ? _value.partnerType
                : partnerType // ignore: cast_nullable_to_non_nullable
                      as String?,
            loginStatus: null == loginStatus
                ? _value.loginStatus
                : loginStatus // ignore: cast_nullable_to_non_nullable
                      as AuthLoginStatus,
            loginErrorMessage: freezed == loginErrorMessage
                ? _value.loginErrorMessage
                : loginErrorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
            session: freezed == session
                ? _value.session
                : session // ignore: cast_nullable_to_non_nullable
                      as SessionEntity?,
            mustChangePassword: null == mustChangePassword
                ? _value.mustChangePassword
                : mustChangePassword // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AuthStateImplCopyWith<$Res>
    implements $AuthStateCopyWith<$Res> {
  factory _$$AuthStateImplCopyWith(
    _$AuthStateImpl value,
    $Res Function(_$AuthStateImpl) then,
  ) = __$$AuthStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    UserRole selectedRole,
    bool isAuthenticated,
    String workContext,
    String? selectedPartner,
    IconData? partnerIcon,
    String? partnerType,
    AuthLoginStatus loginStatus,
    String? loginErrorMessage,
    SessionEntity? session,
    bool mustChangePassword,
  });
}

/// @nodoc
class __$$AuthStateImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthStateImpl>
    implements _$$AuthStateImplCopyWith<$Res> {
  __$$AuthStateImplCopyWithImpl(
    _$AuthStateImpl _value,
    $Res Function(_$AuthStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedRole = null,
    Object? isAuthenticated = null,
    Object? workContext = null,
    Object? selectedPartner = freezed,
    Object? partnerIcon = freezed,
    Object? partnerType = freezed,
    Object? loginStatus = null,
    Object? loginErrorMessage = freezed,
    Object? session = freezed,
    Object? mustChangePassword = null,
  }) {
    return _then(
      _$AuthStateImpl(
        selectedRole: null == selectedRole
            ? _value.selectedRole
            : selectedRole // ignore: cast_nullable_to_non_nullable
                  as UserRole,
        isAuthenticated: null == isAuthenticated
            ? _value.isAuthenticated
            : isAuthenticated // ignore: cast_nullable_to_non_nullable
                  as bool,
        workContext: null == workContext
            ? _value.workContext
            : workContext // ignore: cast_nullable_to_non_nullable
                  as String,
        selectedPartner: freezed == selectedPartner
            ? _value.selectedPartner
            : selectedPartner // ignore: cast_nullable_to_non_nullable
                  as String?,
        partnerIcon: freezed == partnerIcon
            ? _value.partnerIcon
            : partnerIcon // ignore: cast_nullable_to_non_nullable
                  as IconData?,
        partnerType: freezed == partnerType
            ? _value.partnerType
            : partnerType // ignore: cast_nullable_to_non_nullable
                  as String?,
        loginStatus: null == loginStatus
            ? _value.loginStatus
            : loginStatus // ignore: cast_nullable_to_non_nullable
                  as AuthLoginStatus,
        loginErrorMessage: freezed == loginErrorMessage
            ? _value.loginErrorMessage
            : loginErrorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        session: freezed == session
            ? _value.session
            : session // ignore: cast_nullable_to_non_nullable
                  as SessionEntity?,
        mustChangePassword: null == mustChangePassword
            ? _value.mustChangePassword
            : mustChangePassword // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$AuthStateImpl implements _AuthState {
  const _$AuthStateImpl({
    this.selectedRole = UserRole.citizen,
    this.isAuthenticated = false,
    this.workContext = 'CitizenOne',
    this.selectedPartner,
    this.partnerIcon,
    this.partnerType,
    this.loginStatus = AuthLoginStatus.initial,
    this.loginErrorMessage,
    this.session,
    this.mustChangePassword = false,
  });

  @override
  @JsonKey()
  final UserRole selectedRole;
  @override
  @JsonKey()
  final bool isAuthenticated;
  @override
  @JsonKey()
  final String workContext;
  @override
  final String? selectedPartner;
  @override
  final IconData? partnerIcon;
  @override
  final String? partnerType;

  /// Tracks the agent login flow lifecycle so the UI can show
  /// loading, surface failures, and prevent duplicate submissions.
  @override
  @JsonKey()
  final AuthLoginStatus loginStatus;

  /// Holds the latest error message for display.
  @override
  final String? loginErrorMessage;

  /// Active session details. Populated after a successful login and
  /// also hydrated from local storage when the app starts.
  @override
  final SessionEntity? session;

  /// True when the most recent successful login signalled that the
  /// agent must change their password before a normal session is
  /// issued. The login screen uses this to route the agent to the
  /// change-password flow instead of the role dashboard.
  ///
  /// Note: this flag is intentionally duplicated at the state level
  /// (it's also available on [session.mustChangePassword]) so the
  /// LoginScreen listener can branch on it without having to read
  /// the optional [session] field.
  @override
  @JsonKey()
  final bool mustChangePassword;

  @override
  String toString() {
    return 'AuthState(selectedRole: $selectedRole, isAuthenticated: $isAuthenticated, workContext: $workContext, selectedPartner: $selectedPartner, partnerIcon: $partnerIcon, partnerType: $partnerType, loginStatus: $loginStatus, loginErrorMessage: $loginErrorMessage, session: $session, mustChangePassword: $mustChangePassword)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthStateImpl &&
            (identical(other.selectedRole, selectedRole) ||
                other.selectedRole == selectedRole) &&
            (identical(other.isAuthenticated, isAuthenticated) ||
                other.isAuthenticated == isAuthenticated) &&
            (identical(other.workContext, workContext) ||
                other.workContext == workContext) &&
            (identical(other.selectedPartner, selectedPartner) ||
                other.selectedPartner == selectedPartner) &&
            (identical(other.partnerIcon, partnerIcon) ||
                other.partnerIcon == partnerIcon) &&
            (identical(other.partnerType, partnerType) ||
                other.partnerType == partnerType) &&
            (identical(other.loginStatus, loginStatus) ||
                other.loginStatus == loginStatus) &&
            (identical(other.loginErrorMessage, loginErrorMessage) ||
                other.loginErrorMessage == loginErrorMessage) &&
            (identical(other.session, session) || other.session == session) &&
            (identical(other.mustChangePassword, mustChangePassword) ||
                other.mustChangePassword == mustChangePassword));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    selectedRole,
    isAuthenticated,
    workContext,
    selectedPartner,
    partnerIcon,
    partnerType,
    loginStatus,
    loginErrorMessage,
    session,
    mustChangePassword,
  );

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthStateImplCopyWith<_$AuthStateImpl> get copyWith =>
      __$$AuthStateImplCopyWithImpl<_$AuthStateImpl>(this, _$identity);
}

abstract class _AuthState implements AuthState {
  const factory _AuthState({
    final UserRole selectedRole,
    final bool isAuthenticated,
    final String workContext,
    final String? selectedPartner,
    final IconData? partnerIcon,
    final String? partnerType,
    final AuthLoginStatus loginStatus,
    final String? loginErrorMessage,
    final SessionEntity? session,
    final bool mustChangePassword,
  }) = _$AuthStateImpl;

  @override
  UserRole get selectedRole;
  @override
  bool get isAuthenticated;
  @override
  String get workContext;
  @override
  String? get selectedPartner;
  @override
  IconData? get partnerIcon;
  @override
  String? get partnerType;

  /// Tracks the agent login flow lifecycle so the UI can show
  /// loading, surface failures, and prevent duplicate submissions.
  @override
  AuthLoginStatus get loginStatus;

  /// Holds the latest error message for display.
  @override
  String? get loginErrorMessage;

  /// Active session details. Populated after a successful login and
  /// also hydrated from local storage when the app starts.
  @override
  SessionEntity? get session;

  /// True when the most recent successful login signalled that the
  /// agent must change their password before a normal session is
  /// issued. The login screen uses this to route the agent to the
  /// change-password flow instead of the role dashboard.
  ///
  /// Note: this flag is intentionally duplicated at the state level
  /// (it's also available on [session.mustChangePassword]) so the
  /// LoginScreen listener can branch on it without having to read
  /// the optional [session] field.
  @override
  bool get mustChangePassword;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthStateImplCopyWith<_$AuthStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
