// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'set_password_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SetPasswordState {
  /// Mobile number carried from the login screen so the user
  /// doesn't have to re-type it.
  String get mobileNumber => throw _privateConstructorUsedError;

  /// Temporary / old password **entered by the user** in the form.
  ///
  /// This is intentionally distinct from any value passed via the
  /// router's `extra:` payload — the Temporary Password field is
  /// always empty on first render and the user must type it.
  String get temporaryPassword => throw _privateConstructorUsedError;

  /// New password entered by the user (in-flight value).
  String get newPassword => throw _privateConstructorUsedError;

  /// Confirmation password entered by the user.
  String get confirmPassword => throw _privateConstructorUsedError;

  /// Tracks the change-password lifecycle so the UI can show
  /// loading, surface failures, and prevent duplicate submissions.
  SetPasswordStatus get status => throw _privateConstructorUsedError;

  /// Holds the latest error message for display.
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of SetPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SetPasswordStateCopyWith<SetPasswordState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SetPasswordStateCopyWith<$Res> {
  factory $SetPasswordStateCopyWith(
    SetPasswordState value,
    $Res Function(SetPasswordState) then,
  ) = _$SetPasswordStateCopyWithImpl<$Res, SetPasswordState>;
  @useResult
  $Res call({
    String mobileNumber,
    String temporaryPassword,
    String newPassword,
    String confirmPassword,
    SetPasswordStatus status,
    String? errorMessage,
  });
}

/// @nodoc
class _$SetPasswordStateCopyWithImpl<$Res, $Val extends SetPasswordState>
    implements $SetPasswordStateCopyWith<$Res> {
  _$SetPasswordStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SetPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mobileNumber = null,
    Object? temporaryPassword = null,
    Object? newPassword = null,
    Object? confirmPassword = null,
    Object? status = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            mobileNumber: null == mobileNumber
                ? _value.mobileNumber
                : mobileNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            temporaryPassword: null == temporaryPassword
                ? _value.temporaryPassword
                : temporaryPassword // ignore: cast_nullable_to_non_nullable
                      as String,
            newPassword: null == newPassword
                ? _value.newPassword
                : newPassword // ignore: cast_nullable_to_non_nullable
                      as String,
            confirmPassword: null == confirmPassword
                ? _value.confirmPassword
                : confirmPassword // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as SetPasswordStatus,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SetPasswordStateImplCopyWith<$Res>
    implements $SetPasswordStateCopyWith<$Res> {
  factory _$$SetPasswordStateImplCopyWith(
    _$SetPasswordStateImpl value,
    $Res Function(_$SetPasswordStateImpl) then,
  ) = __$$SetPasswordStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String mobileNumber,
    String temporaryPassword,
    String newPassword,
    String confirmPassword,
    SetPasswordStatus status,
    String? errorMessage,
  });
}

/// @nodoc
class __$$SetPasswordStateImplCopyWithImpl<$Res>
    extends _$SetPasswordStateCopyWithImpl<$Res, _$SetPasswordStateImpl>
    implements _$$SetPasswordStateImplCopyWith<$Res> {
  __$$SetPasswordStateImplCopyWithImpl(
    _$SetPasswordStateImpl _value,
    $Res Function(_$SetPasswordStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SetPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mobileNumber = null,
    Object? temporaryPassword = null,
    Object? newPassword = null,
    Object? confirmPassword = null,
    Object? status = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$SetPasswordStateImpl(
        mobileNumber: null == mobileNumber
            ? _value.mobileNumber
            : mobileNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        temporaryPassword: null == temporaryPassword
            ? _value.temporaryPassword
            : temporaryPassword // ignore: cast_nullable_to_non_nullable
                  as String,
        newPassword: null == newPassword
            ? _value.newPassword
            : newPassword // ignore: cast_nullable_to_non_nullable
                  as String,
        confirmPassword: null == confirmPassword
            ? _value.confirmPassword
            : confirmPassword // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as SetPasswordStatus,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$SetPasswordStateImpl implements _SetPasswordState {
  const _$SetPasswordStateImpl({
    this.mobileNumber = '',
    this.temporaryPassword = '',
    this.newPassword = '',
    this.confirmPassword = '',
    this.status = SetPasswordStatus.initial,
    this.errorMessage,
  });

  /// Mobile number carried from the login screen so the user
  /// doesn't have to re-type it.
  @override
  @JsonKey()
  final String mobileNumber;

  /// Temporary / old password **entered by the user** in the form.
  ///
  /// This is intentionally distinct from any value passed via the
  /// router's `extra:` payload — the Temporary Password field is
  /// always empty on first render and the user must type it.
  @override
  @JsonKey()
  final String temporaryPassword;

  /// New password entered by the user (in-flight value).
  @override
  @JsonKey()
  final String newPassword;

  /// Confirmation password entered by the user.
  @override
  @JsonKey()
  final String confirmPassword;

  /// Tracks the change-password lifecycle so the UI can show
  /// loading, surface failures, and prevent duplicate submissions.
  @override
  @JsonKey()
  final SetPasswordStatus status;

  /// Holds the latest error message for display.
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'SetPasswordState(mobileNumber: $mobileNumber, temporaryPassword: $temporaryPassword, newPassword: $newPassword, confirmPassword: $confirmPassword, status: $status, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SetPasswordStateImpl &&
            (identical(other.mobileNumber, mobileNumber) ||
                other.mobileNumber == mobileNumber) &&
            (identical(other.temporaryPassword, temporaryPassword) ||
                other.temporaryPassword == temporaryPassword) &&
            (identical(other.newPassword, newPassword) ||
                other.newPassword == newPassword) &&
            (identical(other.confirmPassword, confirmPassword) ||
                other.confirmPassword == confirmPassword) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    mobileNumber,
    temporaryPassword,
    newPassword,
    confirmPassword,
    status,
    errorMessage,
  );

  /// Create a copy of SetPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SetPasswordStateImplCopyWith<_$SetPasswordStateImpl> get copyWith =>
      __$$SetPasswordStateImplCopyWithImpl<_$SetPasswordStateImpl>(
        this,
        _$identity,
      );
}

abstract class _SetPasswordState implements SetPasswordState {
  const factory _SetPasswordState({
    final String mobileNumber,
    final String temporaryPassword,
    final String newPassword,
    final String confirmPassword,
    final SetPasswordStatus status,
    final String? errorMessage,
  }) = _$SetPasswordStateImpl;

  /// Mobile number carried from the login screen so the user
  /// doesn't have to re-type it.
  @override
  String get mobileNumber;

  /// Temporary / old password **entered by the user** in the form.
  ///
  /// This is intentionally distinct from any value passed via the
  /// router's `extra:` payload — the Temporary Password field is
  /// always empty on first render and the user must type it.
  @override
  String get temporaryPassword;

  /// New password entered by the user (in-flight value).
  @override
  String get newPassword;

  /// Confirmation password entered by the user.
  @override
  String get confirmPassword;

  /// Tracks the change-password lifecycle so the UI can show
  /// loading, surface failures, and prevent duplicate submissions.
  @override
  SetPasswordStatus get status;

  /// Holds the latest error message for display.
  @override
  String? get errorMessage;

  /// Create a copy of SetPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SetPasswordStateImplCopyWith<_$SetPasswordStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
