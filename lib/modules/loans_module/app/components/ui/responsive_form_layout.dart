import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_button.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/base_screen.dart';
import 'package:citizenone_app/modules/loans_module/app/utils/app_colors.dart';

class ResponsiveFormScaffold extends StatelessWidget {
  const ResponsiveFormScaffold({
    super.key,
    required this.appBar,
    required this.isLoading,
    required this.bodyBuilder,
    this.primaryAction,
    this.secondaryAction,
    this.resizeToAvoidBottomInset = true,
  });

  final PreferredSizeWidget appBar;
  final bool isLoading;
  final Widget Function(BuildContext context, bool isWide) bodyBuilder;
  final ResponsiveFormAction? primaryAction;
  final ResponsiveFormAction? secondaryAction;
  final bool resizeToAvoidBottomInset;

  static bool isWideScreen(BuildContext context) =>
      MediaQuery.of(context).size.width > 800;

  @override
  Widget build(BuildContext context) {
    final isWide = isWideScreen(context);

    return Scaffold(
      backgroundColor: AppColors.kF8FAFC,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar: appBar,
      bottomNavigationBar:
          primaryAction == null
              ? null
              : Visibility(
                visible: !isLoading,
                child: ResponsiveFormActions(
                  isWide: isWide,
                  primaryAction: primaryAction!,
                  secondaryAction: secondaryAction,
                ),
              ),
      body: BaseScreen(
        isLoading: isLoading,
        child: ResponsiveFormBody(
          isWide: isWide,
          child: bodyBuilder(context, isWide),
        ),
      ),
    );
  }
}

class ResponsiveFormBody extends StatelessWidget {
  const ResponsiveFormBody({
    super.key,
    required this.child,
    required this.isWide,
    this.mobilePadding = const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 16,
    ),
    this.desktopPadding = const EdgeInsets.symmetric(
      horizontal: 48,
      vertical: 40,
    ),
    this.maxWidth = 1120,
  });

  final Widget child;
  final bool isWide;
  final EdgeInsets mobilePadding;
  final EdgeInsets desktopPadding;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final content =
        isWide
            ? Container(
              width: double.infinity,
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: AppColors.kffffff,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: child,
            )
            : child;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: isWide ? desktopPadding : mobilePadding,
      child:
          isWide
              ? Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: content,
                ),
              )
              : content,
    );
  }
}

class ResponsiveFormWrap extends StatelessWidget {
  const ResponsiveFormWrap({
    super.key,
    required this.isWide,
    required this.children,
    this.columns = 2,
    this.spacing = 16,
    this.runSpacing = 20,
  });

  final bool isWide;
  final List<ResponsiveFormItem> children;
  final int columns;
  final double spacing;
  final double runSpacing;

  @override
  Widget build(BuildContext context) {
    if (!isWide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            children[i].child,
            if (i != children.length - 1) SizedBox(height: runSpacing),
          ],
        ],
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final itemWidth =
            (availableWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children:
              children.map((item) {
                final width =
                    item.fullWidth
                        ? availableWidth
                        : item.width ??
                            itemWidth * item.span + spacing * (item.span - 1);

                return SizedBox(width: width, child: item.child);
              }).toList(),
        );
      },
    );
  }
}

class ResponsiveAutoWrap extends StatelessWidget {
  const ResponsiveAutoWrap({
    super.key,
    required this.isWide,
    required this.children,
    this.columns = 2,
    this.spacing = 16,
    this.runSpacing = 20,
  });

  final bool isWide;
  final List<Widget> children;
  final int columns;
  final double spacing;
  final double runSpacing;

  @override
  Widget build(BuildContext context) {
    if (!isWide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      );
    }

    final items =
        children.where((child) {
          if (child is SizedBox) {
            return child.width != null || child.child != null;
          }
          return true;
        }).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth =
            (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children:
              items.map((child) {
                final isFullWidth = child is ResponsiveFullWidth;
                return SizedBox(
                  width: isFullWidth ? constraints.maxWidth : itemWidth,
                  child:
                      isFullWidth
                          ? (child as ResponsiveFullWidth).child
                          : child,
                );
              }).toList(),
        );
      },
    );
  }
}

class ResponsiveFullWidth extends StatelessWidget {
  const ResponsiveFullWidth({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}

class ResponsiveFormItem {
  const ResponsiveFormItem({
    required this.child,
    this.span = 1,
    this.fullWidth = false,
    this.width,
  });

  final Widget child;
  final int span;
  final bool fullWidth;
  final double? width;
}

class ResponsiveFormActions extends StatelessWidget {
  const ResponsiveFormActions({
    super.key,
    required this.isWide,
    required this.primaryAction,
    this.secondaryAction,
  });

  final bool isWide;
  final ResponsiveFormAction primaryAction;
  final ResponsiveFormAction? secondaryAction;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:
          isWide
              ? Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (secondaryAction != null) ...[
                      SizedBox(
                        width: 150,
                        child: secondaryAction!.build(isWide: true),
                      ),
                      const SizedBox(width: 16),
                    ],
                    SizedBox(
                      width: 150,
                      child: primaryAction.build(isWide: true),
                    ),
                  ],
                ),
              )
              : Padding(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
                child: primaryAction.build(isWide: false),
              ),
    );
  }
}

class ResponsiveFormAction {
  const ResponsiveFormAction({
    required this.title,
    required this.onTap,
    this.icon,
    this.isOutlined = false,
    this.mobileTitle,
  });

  final String title;
  final String? mobileTitle;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool isOutlined;

  Widget build({required bool isWide}) {
    return AgButton(
      title: isWide ? title : (mobileTitle ?? title),
      onTap: onTap,
      icon: isWide ? null : icon,
      isOutlined: isOutlined,
    );
  }
}
