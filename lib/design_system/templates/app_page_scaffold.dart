import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/design_system/atoms/app_text.dart';

class AppPageScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool showBackButton;
  final PreferredSizeWidget? bottom;
  final Color? backgroundColor;
  final bool resizeToAvoidBottomInset;

  const AppPageScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.showBackButton = true,
    this.bottom,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = true,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    return Scaffold(
      backgroundColor: backgroundColor ?? tokens.background,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar: AppBar(
        leading: showBackButton
            ? IconButton(
                icon: Icon(Icons.arrow_back, color: tokens.textPrimary),
                onPressed: () => context.pop(),
              )
            : null,
        automaticallyImplyLeading: showBackButton,
        title: AppText(title, style: AppTextStyle.headlineSmall, fontWeight: FontWeight.w700),
        centerTitle: false,
        backgroundColor: tokens.surface,
        elevation: 0,
        actions: actions,
        bottom: bottom ??
            PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(color: tokens.outline, height: 1),
            ),
      ),
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
