import 'dart:async';

import 'package:citizenone_app/modules/agency_banking/presentation/screens/login/login_screen.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/AuthService.dart';
import '../../blocs/login_bloc/login_bloc.dart';

abstract class BaseScreenState<T extends StatefulWidget> extends State<T> {
  Color myHexColor = const Color(0xff5c7d33);

  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late final StreamSubscription<dynamic> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _checkConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      if (!mounted) return;
      _updateConnectionStatus(result);
    } catch (e) {
      if (!mounted) return;
      _updateConnectionStatus([ConnectivityResult.none]);
    }
  }

  void _updateConnectionStatus(dynamic result) {
    if (!mounted) return;
    setState(() {
      if (result is List) {
        _connectionStatus = result.cast<ConnectivityResult>();
      } else {
        _connectionStatus = [result as ConnectivityResult];
      }
    });
  }

  /// (Optional) Use this if automatic change detection fails
  void _startPeriodicConnectivityCheck() {
    Timer.periodic(const Duration(seconds: 10), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      _checkConnectivity();
    });
  }

  /// This method returns whether mobile data is available
  bool isMobileDataAvailable() {
    return _connectionStatus.contains(ConnectivityResult.mobile);
  }

  /// Show image based on mobile data connectivity
  Widget buildMobileDataStatusImage() {
    if (_connectionStatus.contains(ConnectivityResult.mobile)) {
      return Image.asset(
        'assets/images/ic_network_online.png', // Connected
        width: 24,
        height: 24,
      );
    } else {
      return Image.asset(
        'assets/images/ic_network_online.png', // Disconnected
        width: 24,
        height: 24,
      );
    }
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(20),
          title: const Center(child: Text("Are you sure?")),
          content: const SizedBox(
            width: 200,
            height: 50,
            child: Center(child: Text("Signing Out....")),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => BlocProvider<LoginBloc>(
                      create: (context) => LoginBloc(AuthService()),
                      child: LoginScreen(),
                    ),
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: AppColors.btnBackground,
              ),
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }
}
