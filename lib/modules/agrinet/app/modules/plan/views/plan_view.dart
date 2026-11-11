import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/ui/ag_appbar.dart';
import '../../../components/ui/ag_button.dart';
import '../../../components/ui/ag_dropdown_option.dart';
import '../../../components/ui/ag_loader.dart';
import '../../../components/ui/ag_textfield.dart';
import '../controllers/plan_controller.dart';
import 'member_card.dart';

class PlanView extends GetView<PlanController> {
  const PlanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9F1ED),

      appBar: AgAppbar(title: "SHG Details", showLogout: true),

      body: Obx(
        () =>
            controller.isLoading.value
                ? Center(child: AgLoader())
                : Column(
                  children: [
                    /// Top banner
                    Container(
                      width: double.infinity,
                      color: const Color(0xFFD0D9D0),
                      padding: const EdgeInsets.all(12),
                      child: const Center(
                        child: Text(
                          "New Application",
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      ),
                    ),

                    /// Main content (fills screen)
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE9F1ED),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade400),
                        ),

                        child: Column(
                          children: [
                            /// Scrollable area for fields
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /// Farm Plan Name
                                    AgTextField(
                                      label: "Farm Plan Name",
                                      controller: controller.planNameCtrl,
                                      name: 'plan_name',
                                    ),

                                    const SizedBox(height: 16),

                                    /// Description
                                    AgTextField(
                                      label: "Farm Plan Description",
                                      controller: controller.planDescCtrl,
                                      maxLines: 2,
                                      name: 'plan_desc',
                                    ),

                                    const SizedBox(height: 8),

                                    /// Dropdown
                                    Obx(
                                      () => AgDropDownOption(
                                        name: "group_id",
                                        label: "Select Group",
                                        items: controller.groupList,
                                        value: controller.selectedGroup.value,

                                        hintText: "Select Group",

                                        onChanged: (selectedOption) {
                                          controller.updateGroup(
                                            selectedOption,
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 16),

                                    /// Dynamic Member Cards (NEW)
                                    Column(
                                      children:
                                          controller.members
                                              .map(
                                                (m) => MemberCard(
                                                  name: m.custName ?? "",
                                                  land: m.reqSecureKey ?? "",
                                                  contributionCtrl:
                                                      m.contributionCtrl,
                                                ),
                                              )
                                              .toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            /// Button at bottom inside container
                            AgButton(
                              width: double.infinity,
                              title: "Save Plan",
                              onTap: controller.savePlan,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
