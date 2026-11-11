import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/ag_text_styles.dart';
import '../../utils/ag_colors.dart';
import '../utils/user_prefs.dart';

class AgAppbar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? leadingOnTap;
  final Function(String)? onSearchChanged;
  final TextEditingController? searchController;

  final bool showLeadingIcon;
  final IconData? leadingIcon;

  /// Show search icon
  final bool showSearch;

  /// Show logout icon
  final bool showLogout;

  /// Additional custom actions
  final List<Widget>? actions;

  const AgAppbar({
    super.key,
    required this.title,
    this.leadingOnTap,
    this.showLeadingIcon = true,
    this.showSearch = false,
    this.showLogout = false,
    this.actions,
    this.onSearchChanged,
    this.leadingIcon = Icons.arrow_back,
    this.searchController,
  });

  @override
  State<AgAppbar> createState() => _AgAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 2);
}

class _AgAppbarState extends State<AgAppbar> {
  bool isSearching = false;
  late TextEditingController searchCtrl;

  @override
  void initState() {
    super.initState();
    searchCtrl = widget.searchController ?? TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppBar(
          backgroundColor: AgColors.colorPrimary,
          elevation: 0,
          titleSpacing: 0,

          /// ---------- LEADING ICON ----------
          leadingWidth: widget.showLeadingIcon ? kToolbarHeight : 0,
          leading:
              widget.showLeadingIcon
                  ? IconButton(
                    icon: Icon(widget.leadingIcon, color: Colors.white),
                    onPressed: widget.leadingOnTap ?? () => Get.back(),
                  )
                  : null,

          /// ---------- TITLE OR SEARCH BAR ----------
          title:
              isSearching
                  ? _buildSearchField()
                  : Text(widget.title, style: kw500White20),

          /// ---------- ACTION BUTTONS ----------
          actions: [
            if (widget.showSearch)
              IconButton(
                icon: Icon(
                  isSearching ? Icons.close : Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    if (isSearching) {
                      searchCtrl.clear();
                    }
                    isSearching = !isSearching;
                    if (widget.onSearchChanged != null) {
                      widget.onSearchChanged!("");
                    }
                  });
                },
              ),

            if (false /*widget.showLogout*/ )
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                onPressed: onTapLogout,
              ),

            if (widget.actions != null) ...widget.actions!,
          ],
        ),
      ],
    );
  }

  /// SEARCH TEXTFIELD (replaces AppBar title)
  Widget _buildSearchField() {
    return TextField(
      controller: searchCtrl,
      autofocus: true,
      cursorColor: Colors.white,
      style: const TextStyle(color: Colors.white, fontSize: 18),
      decoration: const InputDecoration(
        hintText: "Search",
        hintStyle: TextStyle(color: Colors.white70, fontSize: 18),
        border: InputBorder.none,
      ),
      onChanged: (value) {
        if (widget.onSearchChanged != null) {
          widget.onSearchChanged!(value); // ✔ Pass text correctly
        }
      },
    );
  }

  onTapLogout() {
    UserPrefs.logout();
  }
}
