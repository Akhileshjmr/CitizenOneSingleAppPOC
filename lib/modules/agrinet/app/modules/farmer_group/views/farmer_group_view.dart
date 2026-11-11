import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/agrinet/app/data/model/farmer_group/farmer_group_list.dart';
import 'package:citizenone_app/modules/agrinet/app/modules/farmer_group/controllers/farmer_group_controller.dart';
import 'package:citizenone_app/modules/agrinet/app/theme/ag_text_styles.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FarmerGroupView extends GetView<FarmerGroupController> {
  const FarmerGroupView({super.key, required this.members});
  final List<Former> members;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AgColors.kEFFFF2,
      appBar: AgAppbar(title: controller.agApptranslation.groupDetails),
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: 8),
        itemCount: members.length,
        itemBuilder: (context, index) {
          Former member = members[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
            child: Card(
              child: ListTile(
                title: Text(
                  member.farmer!.id.toString(),
                  style: k297B33FS16w600,
                ),
                trailing:
                    member.isLeader == true
                        ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: AgColors.kA13D3F),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text('Leader', style: kA13D3Ffs14w400),
                            ),
                          ],
                        )
                        : SizedBox.shrink(),
                subtitle: Text(
                  member.farmer!.friendlyType!,
                  style: const TextStyle(fontWeight: FontWeight.w400),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
