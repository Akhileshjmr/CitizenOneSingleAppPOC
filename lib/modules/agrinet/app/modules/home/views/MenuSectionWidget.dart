import 'package:citizenone_app/modules/agrinet/app/utils/ag_colors.dart';
import 'package:flutter/material.dart';

import '../../../theme/ag_text_styles.dart';
import 'MenuItemModel.dart';

class MenuSectionWidget extends StatelessWidget {
  final String title;
  final List<MenuItemModel> items;
  final void Function(MenuItemModel) onTap;

  const MenuSectionWidget({
    Key? key,
    required this.title,
    required this.items,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(title, style: kw600Primary16),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, index) {
            final item = items[index];
            return Container(
              color: AgColors.kWhite,
              child: InkWell(
                onTap: () => onTap(item),
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 50, height: 50, child: item.image),
                    const SizedBox(height: 6),
                    Text(
                      item.title,
                      textAlign: TextAlign.center,
                      style: kw400Primary14,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
