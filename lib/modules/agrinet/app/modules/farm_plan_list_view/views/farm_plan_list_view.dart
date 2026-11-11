import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_loader.dart';
import 'package:citizenone_app/modules/agrinet/app/modules/farm_plan_list_view/views/widgets/farm_plan_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/ui/ag_appbar.dart';
import '../../../routes/app_pages.dart';
import '../controllers/farm_plan_list_controller.dart';

class FarmPlanListView extends StatefulWidget {
  const FarmPlanListView({super.key});

  @override
  State<FarmPlanListView> createState() => _FarmPlanListViewState();
}

class _FarmPlanListViewState extends State<FarmPlanListView> {
  final controller = Get.find<FarmPlanListController>();
  final ScrollController scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();

    // Add scroll listener for pagination
    scrollCtrl.addListener(() {
      if (scrollCtrl.position.pixels >=
          scrollCtrl.position.maxScrollExtent - 100) {
        controller.loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AgAppbar(
        title: "Farming Plans",
        showSearch: true,
        onSearchChanged: (value) {
          controller.onSearch(value);
        },
      ),

      body: Obx(() {
        final list = controller.filteredList;
        if (controller.isLoading.value) {
          return const Center(child: AgLoader());
        }
        if (list.isEmpty) {
          return const Center(child: Text("No plans found"));
        }
        return ListView.builder(
          controller: scrollCtrl,
          itemCount: list.length + 1,
          itemBuilder: (_, index) {
            // Loader at last index
            if (index == list.length) {
              return Obx(() {
                return controller.isLoadingMore.value
                    ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: AgLoader()),
                    )
                    : const SizedBox.shrink();
              });
            }

            final item = list[index];

            return FarmPlanListTile(
              item: item,
              onTap: () {
                Get.toNamed(Routes.PROFITABILITY, arguments: item);
              },
            );
          },
        );
      }),
    );
  }
}
