import 'package:citizenone_app/modules/agrinet/app/components/utils/str_ext.dart';
import 'package:citizenone_app/modules/agrinet/app/routes/app_pages.dart';
import 'package:citizenone_app/modules/agrinet/app/theme/ag_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/utils/user_prefs.dart';
import '../../../utils/ag_assets.dart';

class HomeSideMenu extends StatelessWidget {
  const HomeSideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final pal = UserPrefs.user?.palRes;
    final imageUrl = pal?.documents?.imgUrl;
    final name = pal?.firstName ?? "";

    return Drawer(
      width: 270,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===================== HEADER =====================
          Container(
            height: 200,
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AgAssets.sideMenuBackground),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipOval(
                    child:
                        (imageUrl != null && imageUrl.isNotEmpty)
                            ? Image.network(
                              imageUrl.addBaseUrl,
                              width: 76,
                              height: 76,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (_, __, ___) =>
                                      const SizedBox(width: 76, height: 76),
                            )
                            : const SizedBox(),
                  ),
                  SizedBox(height: 16),
                  Text(name, style: kw600White20),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ===================== MENU ITEMS =====================
          _menuTile(
            icon: Icons.account_circle_outlined,
            title: "My Profile",
            onTap: () => Get.toNamed(Routes.MY_PROFILE),
          ),

          _menuTile(
            icon: Icons.notifications_none,
            title: "Notifications",
            onTap: () => Get.toNamed(Routes.NOTIFICATION),
          ),

          _menuTile(
            icon: Icons.create_outlined,
            title: "Pal Creation",
            onTap: () => Get.toNamed(Routes.PAL_CREATION),
          ),

          _menuTile(
            icon: Icons.shopping_bag_outlined,
            title: "Buyer Demands",
            onTap: () => Get.toNamed(Routes.BUYER_DEMANDS),
          ),

          _menuTile(
            icon: Icons.phone_in_talk_outlined,
            title: "Contact Us",
            onTap: () => Get.toNamed(Routes.CONTACT_US),
          ),

          _menuTile(
            icon: Icons.info_outline,
            title: "About Us",
            onTap: () => Get.toNamed(Routes.ABOUT_US),
          ),
        ],
      ),
    );
  }

  Widget _menuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, size: 22, color: Colors.green.shade900),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          color: Colors.grey.shade900,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}
