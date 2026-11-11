import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_loader.dart';
import 'package:citizenone_app/modules/agrinet/app/components/utils/str_ext.dart';
import 'package:citizenone_app/modules/agrinet/app/routes/app_pages.dart';
import 'package:citizenone_app/modules/agrinet/app/theme/ag_text_styles.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_assets.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app_environment.dart';
import '../../../components/ui/home_image_carousal.dart';
import '../controllers/my_profile_controller.dart';

class MyProfileView extends GetView<MyProfileController> {
  const MyProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AgAppbar(title: "My Profile", showLogout: true),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: AgLoader());
        }

        final pal = controller.pal.value;
        if (pal == null) {
          return const Center(child: Text("Profile not found"));
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              // ---------------- HEADER CAROUSEL ------------------
              Obx(() {
                // Show a placeholder if images are still loading
                if (controller.sliderImages.isEmpty) {
                  return Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey.shade200,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }

                return HomeHeaderCarousel(
                  images: controller.sliderImages,
                  currentIndex: controller.currentIndex,
                  carouselController: controller.carouselController,
                  carousalHeight: 200,
                  onPageChanged: (index) {
                    controller.currentIndex.value = index;
                  },
                );
              }),

              _sectionDivider(),

              // ---------------- PAL INFORMATION TITLE ----------------
              _title(
                "Pal Information",
                onEdit: () {
                  Get.toNamed(Routes.EDIT_PROFILE);
                },
              ),

              // ---------------- PROFILE CARD ------------------
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // IMAGE with rounded corners and border
                    Container(
                      width: 100,
                      height: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: Colors.grey.shade400,
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: const Color(0xFFFFB347),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child:
                              pal.documents?.imgUrl != null
                                  ? Image.network(
                                    pal.documents!.imgUrl!.addBaseUrl,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (
                                      context,
                                      child,
                                      loadingProgress,
                                    ) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: Text(
                                          _getInitials(pal.firstName ?? ""),
                                          style: const TextStyle(
                                            fontSize: 48,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(
                                        child: Text(
                                          _getInitials(pal.firstName ?? ""),
                                          style: const TextStyle(
                                            fontSize: 48,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                  : Center(
                                    child: Text(
                                      _getInitials(pal.firstName ?? ""),
                                      style: const TextStyle(
                                        fontSize: 48,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // DETAILS
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name with badge
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  pal.firstName ?? "",
                                  style: kw600Primary18,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Image.asset(
                                AgAssets.badgeBronze,
                                width: 24,
                                height: 24,
                                package: AppEnvironment.packageName,
                              ),
                            ],
                          ),

                          const SizedBox(height: 4),

                          // Email
                          _infoRow("Email Id", pal.email ?? ""),
                          _infoDivider(),

                          // Mobile Number
                          _infoRow("Mobile Number", pal.mobileNum ?? ""),
                          _infoDivider(),

                          // Grade
                          _infoRow("Grade", pal.grade ?? ""),
                          _infoDivider(),

                          // Funding Agency
                          _infoRow("Funding Agency", pal.fundingAgency ?? ""),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              _sectionDivider(),

              // ---------------- MENTORS ------------------
              if (pal.mentor != null && pal.mentor!.isNotEmpty) ...[
                _title("Assigned Mentors"),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children:
                        pal.mentor!.map((m) {
                          return Column(
                            children: [
                              const SizedBox(height: 40),
                              Text(
                                m.mentorName ?? "",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                  ),
                ),
                _sectionDivider(),
              ],

              // ---------------- DESCRIPTION ------------------
              _title("Pal Description"),

              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "The main function of an Agricultural Extension officer is to pass information "
                  "or new innovation from the research institute to the farmers...",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        );
      }),
    );
  }

  // ---------- UI HELPERS ----------
  Widget _title(String text, {VoidCallback? onEdit}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AgColors.colorSecondaryDark,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // LEFT TEXT
          Text(text, style: kw600White16),

          // RIGHT SIDE: Only show if onEdit != null
          if (onEdit != null)
            Row(
              children: [
                // Vertical divider
                Container(
                  width: 1,
                  height: 22,
                  color: Colors.white.withOpacity(0.7),
                  margin: const EdgeInsets.only(right: 10),
                ),

                // Edit icon
                GestureDetector(
                  onTap: onEdit,
                  child: const Icon(Icons.edit, size: 20, color: Colors.white),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
          ),

          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              ": $value",
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoDivider() {
    return Divider(color: Colors.grey.shade300, thickness: 1, height: 1);
  }

  String _getInitials(String name) {
    if (name.isEmpty) return "U";
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  Widget _sectionDivider() {
    return Divider(color: AgColors.colorPrimary, thickness: 5, height: 1);
  }
}
