import 'package:citizenone_app/modules/agency_banking/data/api/end_points/ApiEndPoints.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserInfo.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/login_bloc/login_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/login_bloc/login_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/login_bloc/login_state.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/login/widgets/handleLogin.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AESEncryption.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Silently drives the existing [LoginBloc]/[AuthService] login flow using
/// credentials handed off by a host app (Citizen One), against
/// [ApiEndpoints.citizenUserLogin] instead of the standalone
/// [ApiEndpoints.login] endpoint. Shown in place of [LoginScreen] when
/// Agency Banking is launched as an embedded module — the agent never sees
/// this app's own login UI.
///
/// Reuses [handleLoginState] unchanged on success, so the real tenant/bank
/// picker (`BankSelectionScreen`) still runs exactly as it does standalone.
class AutoLoginScreen extends StatefulWidget {
  final String phone;
  final String password;
  final VoidCallback? onExit;

  const AutoLoginScreen({
    super.key,
    required this.phone,
    required this.password,
    this.onExit,
  });

  @override
  State<AutoLoginScreen> createState() => _AutoLoginScreenState();
}

class _AutoLoginScreenState extends State<AutoLoginScreen> {
  String? _encryptionError;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _submit());
  }

  void _submit() {
    if (!mounted) return;
    setState(() {
      _encryptionError = null;
      _failed = false;
    });

    try {
      final loginUserReqResInfo = LoginUserReqResInfo()
        ..headerInfo.initialAccess = true
        ..loginUserInfo = (LoginUserInfo()
          ..userName = AESEncryptionService.encrypt(widget.phone)
          ..password = AESEncryptionService.encrypt(widget.password)
          ..deviceID = AESEncryptionService.encrypt('Bindu12334'));

      context.read<LoginBloc>().add(LoginSubmitted(
            loginUserReqResInfo,
            endpointOverride: ApiEndpoints.citizenUserLogin,
          ));
    } catch (e) {
      AppLogger.error('Auto-login: failed to prepare credentials', e);
      setState(() {
        _encryptionError = 'Unable to prepare your sign-in details.';
        _failed = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_encryptionError != null) {
      return _AutoLoginError(
        message: _encryptionError!,
        onRetry: _submit,
        onBack: widget.onExit,
      );
    }

    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          handleLoginState(context, state);
        } else if (state is LoginFailure) {
          setState(() => _failed = true);
          handleLoginState(context, state);
        }
      },
      builder: (context, state) {
        if (_failed && state is! LoginLoading) {
          return _AutoLoginError(
            message: state is LoginFailure
                ? state.error
                : 'Sign-in failed. Please try again.',
            onRetry: _submit,
            onBack: widget.onExit,
          );
        }
        return const Scaffold(
          backgroundColor: AppColors.bgColorScreen,
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

class _AutoLoginError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final VoidCallback? onBack;

  const _AutoLoginError({
    required this.message,
    required this.onRetry,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColorScreen,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: onRetry,
                  child: const Text('Retry'),
                ),
                if (onBack != null) ...[
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: onBack,
                    child: const Text('Back'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
