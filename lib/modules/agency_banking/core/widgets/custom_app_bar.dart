import 'dart:async';

import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:citizenone_app/modules/agency_banking/utils/CommSuccessDialogues.dart';
import 'package:flutter/material.dart';

import '../../utils/CommDialog.dart';
import '../services/connectivity_service.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBack;
  final bool showLogout;
  final PreferredSizeWidget? bottom;
  final VoidCallback? onBack;

  final TextStyle? titleStyle;

  /// Custom leading widget (Menu, Logo, etc.)
  final Widget? leadingWidget;

  /// Custom action widgets
  final List<Widget>? customActions;

  /// Center title
  final bool centerTitle;

  /// Toolbar height
  final double toolbarHeight;

  final Color backgroundColor;

  const CustomAppBar({
    Key? key,
    this.title,
    this.showBack = true,
    this.showLogout = true,
    this.bottom,
    this.onBack,
    this.leadingWidget,
    this.customActions,
    this.centerTitle = true,
    this.toolbarHeight = 80,
    this.backgroundColor = AppColors.toolBarBackground,
    this.titleStyle,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(
        toolbarHeight + (bottom?.preferredSize.height ?? 0),
      );

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool isConnected = true;
  StreamSubscription<bool>? _subscription;

  @override
  void initState() {
    super.initState();
    _initConnectivityListener();
  }

  void _initConnectivityListener() async {
    isConnected = await ConnectivityService.hasConnection();

    if (mounted) {
      setState(() {});
    }

    _subscription = ConnectivityService.connectionStream.listen((connected) {
      if (!mounted) return;

      setState(() {
        isConnected = connected;
      });

      if (!connected) {
        showCustomBottomPopup(
          context,
          "You're offline. Please check your internet connection and try again.",
        );
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: widget.backgroundColor,
      elevation: 0,
      toolbarHeight: widget.toolbarHeight,
      centerTitle: widget.centerTitle,
      bottom: widget.bottom,
      leadingWidth: 72,

      /// Leading
      leading: widget.leadingWidget ??
          (widget.showBack
              ? IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppColors.iconsBackground,
                  ),
                  onPressed: widget.onBack ?? () => Navigator.of(context).pop(),
                )
              : null),

      /// Title
      title: widget.title != null
          ? Text(
              widget.title!,
              style: widget.titleStyle ??
                  const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
            )
          : null,

      /// Actions
      actions: widget.customActions ??
          [
            if (widget.showLogout) ...[
              Icon(
                Icons.circle,
                color: isConnected ? Colors.green : Colors.red,
                size: 12,
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(
                  Icons.logout,
                  color: AppColors.iconsBackground,
                ),
                onPressed: () => showLogoutDialog(context),
              ),
            ],
          ],
    );
  }
}
