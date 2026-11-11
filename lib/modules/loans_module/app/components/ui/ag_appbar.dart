import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/utils/app_colors.dart';

class AgAppbar extends StatefulWidget implements PreferredSizeWidget {
  final String title;

  /// Optional custom leading builder
  final WidgetBuilder? builder;

  final VoidCallback? leadingOnTap;

  final bool showLeadingIcon;
  final IconData? leadingIcon;

  /// Additional custom actions
  final List<Widget>? actions;
  final bool centerTitle;
  final bool showDivider;

  const AgAppbar({
    super.key,
    required this.title,
    this.builder,
    this.leadingOnTap,
    this.showLeadingIcon = true,
    this.actions,
    this.leadingIcon = Icons.arrow_back,
    this.centerTitle = false,
    this.showDivider = true,
  });

  @override
  State<AgAppbar> createState() => _AgAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AgAppbarState extends State<AgAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: 0,
      centerTitle: widget.centerTitle,
      backgroundColor: AppColors.kffffff,

      /// ---------- LEADING ----------
      leadingWidth: widget.showLeadingIcon ? kToolbarHeight : 0,
      leading: _buildLeading(context),

      /// ---------- TITLE ----------
      title: Text(
        widget.title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      /// ---------- ACTIONS ----------
      actions: widget.actions,

      /// ---------- OPTIONAL BOTTOM BORDER ----------
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Visibility(
          visible: widget.showDivider,
          child: const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFE0E0E0),
          ),
        ),
      ),
    );
  }

  /// ---------- LEADING ----------
  Widget? _buildLeading(BuildContext context) {
    if (!widget.showLeadingIcon) return null;

    if (widget.builder != null) {
      return Builder(builder: widget.builder!);
    }

    return IconButton(
      icon: Icon(
        widget.leadingIcon,
        color: Colors.black, // black arrow
      ),
      onPressed: widget.leadingOnTap ?? () => Get.back(),
    );
  }
}
