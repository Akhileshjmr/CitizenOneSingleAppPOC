import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/design_system/atoms/app_text.dart';



class ServicePageTemplate extends StatelessWidget {
  final String title;
  final LinearGradient? headerGradient;
  final Widget headerContent;
  final Widget body;
  final List<Widget>? appBarActions;
  final double headerHeight;

  const ServicePageTemplate({
    super.key,
    required this.title,
    required this.headerContent,
    required this.body,
    this.headerGradient,
    this.appBarActions,
    this.headerHeight = 200,
  });
  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    final gradient = headerGradient ?? tokens.heroGradient;

    return Scaffold(
      backgroundColor: tokens.background,
      body: CustomScrollView(
        slivers: [
          TextFormField(keyboardType: TextInputType.number),
          SliverAppBar(
            expandedHeight: headerHeight,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            backgroundColor: gradient.colors.first,
            elevation: 0,
            actions: appBarActions,
            title: AppText(
              title,
              style: AppTextStyle.headlineSmall,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(gradient: gradient),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      tokens.spacingXl,
                      56,
                      tokens.spacingXl,
                      tokens.spacingXl,
                    ),
                    child: headerContent,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: body),
        ],
      ),
    );
  }
}
