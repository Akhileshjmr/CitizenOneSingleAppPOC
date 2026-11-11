// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'forgot_password_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ForgotPasswordState {
  /// Mobile number carried from the Forgot-Password screen and
  /// re-used by the Verify-OTP, Resend-OTP and Reset-Password calls.
  String get mobileNumber => throw _privateConstructorUsedError;

  /// 6-digit OTP the user typed. Mirrored from the Pinput controller
  /// so the cubit knows when the field is complete.
  String get otp => throw _privateConstructorUsedError;

  /// Resend-OTP cooldown (seconds remaining). Counts down every
  /// second while > 0. When this hits 0 the resend button is
  /// enabled. Distinct from [otpExpiresInSeconds] — this only gates
  /// the "Resend OTP" button.
  int get resendCooldown => throw _privateConstructorUsedError;

  /// OTP/session expiration countdown (seconds remaining), seeded
  /// from the API's `otpExpiresInSeconds`. Displayed as the timer on
  /// the OTP screen. Counts down independently of [resendCooldown].
  int get otpExpiresInSeconds => throw _privateConstructorUsedError;

  /// Attempts remaining for the current OTP. The API may return this
  /// on the resend response.
  int get attemptsRemaining => throw _privateConstructorUsedError;

  /// Maximum attempts allowed (reported by the API when available).
  int get maxAttempts => throw _privateConstructorUsedError;

  /// Latest human-readable error message.
  String? get errorMessage => throw _privateConstructorUsedError;

  /// The active flow phase.
  ForgotPasswordStatus get status => throw _privateConstructorUsedError;

  /// Create a copy of ForgotPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ForgotPasswordStateCopyWith<ForgotPasswordState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ForgotPasswordStateCopyWith<$Res> {
  factory $ForgotPasswordStateCopyWith(
    ForgotPasswordState value,
    $Res Function(ForgotPasswordState) then,
  ) = _$ForgotPasswordStateCopyWithImpl<$Res, ForgotPasswordState>;
  @useResult
  $Res call({
    String mobileNumber,
    String otp,
    int resendCooldown,
    int otpExpiresInSeconds,
    int attemptsRemaining,
    int maxAttempts,
    String? errorMessage,
    ForgotPasswordStatus status,
  });
}

/// @nodoc
class _$ForgotPasswordStateCopyWithImpl<$Res, $Val extends ForgotPasswordState>
    implements $ForgotPasswordStateCopyWith<$Res> {
  _$ForgotPasswordStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ForgotPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mobileNumber = null,
    Object? otp = null,
    Object? resendCooldown = null,
    Object? otpExpiresInSeconds = null,
    Object? attemptsRemaining = null,
    Object? maxAttempts = null,
    Object? errorMessage = freezed,
    Object? status = null,
  }) {
    return _then(
      _value.copyWith(
            mobileNumber: null == mobileNumber
                ? _value.mobileNumber
                : mobileNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            otp: null == otp
                ? _value.otp
                : otp // ignore: cast_nullable_to_non_nullable
                      as String,
            resendCooldown: null == resendCooldown
                ? _value.resendCooldown
                : resendCooldown // ignore: cast_nullable_to_non_nullable
                      as int,
            otpExpiresInSeconds: null == otpExpiresInSeconds
                ? _value.otpExpiresInSeconds
                : otpExpiresInSeconds // ignore: cast_nullable_to_non_nullable
                      as int,
            attemptsRemaining: null == attemptsRemaining
                ? _value.attemptsRemaining
                : attemptsRemaining // ignore: cast_nullable_to_non_nullable
                      as int,
            maxAttempts: null == maxAttempts
                ? _value.maxAttempts
                : maxAttempts // ignore: cast_nullable_to_non_nullable
                      as int,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as ForgotPasswordStatus,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ForgotPasswordStateImplCopyWith<$Res>
    implements $ForgotPasswordStateCopyWith<$Res> {
  factory _$$ForgotPasswordStateImplCopyWith(
    _$ForgotPasswordStateImpl value,
    $Res Function(_$ForgotPasswordStateImpl) then,
  ) = __$$ForgotPasswordStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String mobileNumber,
    String otp,
    int resendCooldown,
    int otpExpiresInSeconds,
    int attemptsRemaining,
    int maxAttempts,
    String? errorMessage,
    ForgotPasswordStatus status,
  });
}

/// @nodoc
class __$$ForgotPasswordStateImplCopyWithImpl<$Res>
    extends _$ForgotPasswordStateCopyWithImpl<$Res, _$ForgotPasswordStateImpl>
    implements _$$ForgotPasswordStateImplCopyWith<$Res> {
  __$$ForgotPasswordStateImplCopyWithImpl(
    _$ForgotPasswordStateImpl _value,
    $Res Function(_$ForgotPasswordStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ForgotPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mobileNumber = null,
    Object? otp = null,
    Object? resendCooldown = null,
    Object? otpExpiresInSeconds = null,
    Object? attemptsRemaining = null,
    Object? maxAttempts = null,
    Object? errorMessage = freezed,
    Object? status = null,
  }) {
    return _then(
      _$ForgotPasswordStateImpl(
        mobileNumber: null == mobileNumber
            ? _value.mobileNumber
            : mobileNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        otp: null == otp
            ? _value.otp
            : otp // ignore: cast_nullable_to_non_nullable
                  as String,
        resendCooldown: null == resendCooldown
            ? _value.resendCooldown
            : resendCooldown // ignore: cast_nullable_to_non_nullable
                  as int,
        otpExpiresInSeconds: null == otpExpiresInSeconds
            ? _value.otpExpiresInSeconds
            : otpExpiresInSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        attemptsRemaining: null == attemptsRemaining
            ? _value.attemptsRemaining
            : attemptsRemaining // ignore: cast_nullable_to_non_nullable
                  as int,
        maxAttempts: null == maxAttempts
            ? _value.maxAttempts
            : maxAttempts // ignore: cast_nullable_to_non_nullable
                  as int,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as ForgotPasswordStatus,
      ),
    );
  }
}

/// @nodoc

class _$ForgotPasswordStateImpl implements _ForgotPasswordState {
  const _$ForgotPasswordStateImpl({
    this.mobileNumber = '',
    this.otp = '',
    this.resendCooldown = 0,
    this.otpExpiresInSeconds = 0,
    this.attemptsRemaining = 5,
    this.maxAttempts = 5,
    this.errorMessage,
    this.status = ForgotPasswordStatus.initial,
  });

  /// Mobile number carried from the Forgot-Password screen and
  /// re-used by the Verify-OTP, Resend-OTP and Reset-Password calls.
  @override
  @JsonKey()
  final String mobileNumber;

  /// 6-digit OTP the user typed. Mirrored from the Pinput controller
  /// so the cubit knows when the field is complete.
  @override
  @JsonKey()
  final String otp;

  /// Resend-OTP cooldown (seconds remaining). Counts down every
  /// second while > 0. When this hits 0 the resend button is
  /// enabled. Distinct from [otpExpiresInSeconds] — this only gates
  /// the "Resend OTP" button.
  @override
  @JsonKey()
  final int resendCooldown;

  /// OTP/session expiration countdown (seconds remaining), seeded
  /// from the API's `otpExpiresInSeconds`. Displayed as the timer on
  /// the OTP screen. Counts down independently of [resendCooldown].
  @override
  @JsonKey()
  final int otpExpiresInSeconds;

  /// Attempts remaining for the current OTP. The API may return this
  /// on the resend response.
  @override
  @JsonKey()
  final int attemptsRemaining;

  /// Maximum attempts allowed (reported by the API when available).
  @override
  @JsonKey()
  final int maxAttempts;

  /// Latest human-readable error message.
  @override
  final String? errorMessage;

  /// The active flow phase.
  @override
  @JsonKey()
  final ForgotPasswordStatus status;

  @override
  String toString() {
    return 'ForgotPasswordState(mobileNumber: $mobileNumber, otp: $otp, resendCooldown: $resendCooldown, otpExpiresInSeconds: $otpExpiresInSeconds, attemptsRemaining: $attemptsRemaining, maxAttempts: $maxAttempts, errorMessage: $errorMessage, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ForgotPasswordStateImpl &&
            (identical(other.mobileNumber, mobileNumber) ||
                other.mobileNumber == mobileNumber) &&
            (identical(other.otp, otp) || other.otp == otp) &&
            (identical(other.resendCooldown, resendCooldown) ||
                other.resendCooldown == resendCooldown) &&
            (identical(other.otpExpiresInSeconds, otpExpiresInSeconds) ||
                other.otpExpiresInSeconds == otpExpiresInSeconds) &&
            (identical(other.attemptsRemaining, attemptsRemaining) ||
                other.attemptsRemaining == attemptsRemaining) &&
            (identical(other.maxAttempts, maxAttempts) ||
                other.maxAttempts == maxAttempts) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    mobileNumber,
    otp,
    resendCooldown,
    otpExpiresInSeconds,
    attemptsRemaining,
    maxAttempts,
    errorMessage,
    status,
  );

  /// Create a copy of ForgotPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ForgotPasswordStateImplCopyWith<_$ForgotPasswordStateImpl> get copyWith =>
      __$$ForgotPasswordStateImplCopyWithImpl<_$ForgotPasswordStateImpl>(
        this,
        _$identity,
      );
}

abstract class _ForgotPasswordState implements ForgotPasswordState {
  const factory _ForgotPasswordState({
    final String mobileNumber,
    final String otp,
    final int resendCooldown,
    final int otpExpiresInSeconds,
    final int attemptsRemaining,
    final int maxAttempts,
    final String? errorMessage,
    final ForgotPasswordStatus status,
  }) = _$ForgotPasswordStateImpl;

  /// Mobile number carried from the Forgot-Password screen and
  /// re-used by the Verify-OTP, Resend-OTP and Reset-Password calls.
  @override
  String get mobileNumber;

  /// 6-digit OTP the user typed. Mirrored from the Pinput controller
  /// so the cubit knows when the field is complete.
  @override
  String get otp;

  /// Resend-OTP cooldown (seconds remaining). Counts down every
  /// second while > 0. When this hits 0 the resend button is
  /// enabled. Distinct from [otpExpiresInSeconds] — this only gates
  /// the "Resend OTP" button.
  @override
  int get resendCooldown;

  /// OTP/session expiration countdown (seconds remaining), seeded
  /// from the API's `otpExpiresInSeconds`. Displayed as the timer on
  /// the OTP screen. Counts down independently of [resendCooldown].
  @override
  int get otpExpiresInSeconds;

  /// Attempts remaining for the current OTP. The API may return this
  /// on the resend response.
  @override
  int get attemptsRemaining;

  /// Maximum attempts allowed (reported by the API when available).
  @override
  int get maxAttempts;

  /// Latest human-readable error message.
  @override
  String? get errorMessage;

  /// The active flow phase.
  @override
  ForgotPasswordStatus get status;

  /// Create a copy of ForgotPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ForgotPasswordStateImplCopyWith<_$ForgotPasswordStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
