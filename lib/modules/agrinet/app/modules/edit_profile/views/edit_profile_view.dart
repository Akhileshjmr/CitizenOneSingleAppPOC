import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_button.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_loader.dart';
import 'package:citizenone_app/modules/agrinet/app/components/utils/str_ext.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../components/ui/ag_appbar.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AgAppbar(title: "Update Details"),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: AgLoader());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: controller.updateFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),

                /// PROFILE IMAGE
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage:
                          controller.pickedImage.value != null
                              ? FileImage(controller.pickedImage.value!)
                              : controller.profileImageUrl.value != null
                              ? NetworkImage(
                                    controller
                                        .profileImageUrl
                                        .value!
                                        .addBaseUrl,
                                  )
                                  as ImageProvider
                              : null,
                      child:
                          controller.pickedImage.value == null &&
                                  (controller.profileImageUrl.value == null ||
                                      controller.profileImageUrl.value!.isEmpty)
                              ? const Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.white,
                              )
                              : null,
                    ),
                    Positioned(
                      bottom: 5,
                      right: 5,
                      child: GestureDetector(
                        onTap: () => _showImagePicker(context),
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.camera_alt,
                            size: 20,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                _buildTextField(
                  label: "First Name",
                  controller: controller.nameCtrl,
                  validator:
                      (v) =>
                          v!.trim().isEmpty ? "Please enter your name" : null,
                ),

                const SizedBox(height: 16),

                _buildTextField(
                  label: "Email Address",
                  controller: controller.emailCtrl,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email is required";
                    }
                    if (!RegExp(r"^[\w\.-]+@[\w\.-]+\.\w+$").hasMatch(value)) {
                      return "Enter a valid email";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 32),

                /// UPDATE BUTTON
                AgButton(
                  width: double.infinity,
                  title: "UPDATE",
                  onTap:
                      controller.isLoading.value
                          ? () {}
                          : () => controller.updateProfile(),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  /// BOTTOM SHEET FOR IMAGE PICKER
  void _showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder:
          (ctx) => Container(
            padding: const EdgeInsets.all(20),
            height: 160,
            child: Column(
              children: [
                const Text(
                  "Select Image",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                        controller.pickImage(ImageSource.camera);
                      },
                      child: const Column(
                        children: [
                          Icon(Icons.camera_alt, size: 40),
                          SizedBox(height: 5),
                          Text("Camera"),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                        controller.pickImage(ImageSource.gallery);
                      },
                      child: const Column(
                        children: [
                          Icon(Icons.photo_library, size: 40),
                          SizedBox(height: 5),
                          Text("Gallery"),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          cursorColor: Color(0xFF355E3B),
          decoration: InputDecoration(
            filled: true,
            fillColor: AgColors.kWhite,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300, width: 0.5),
              borderRadius: BorderRadius.circular(6),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF355E3B)),
              borderRadius: BorderRadius.circular(6),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AgColors.warning),
              borderRadius: BorderRadius.circular(6),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AgColors.warning),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      ],
    );
  }
}
