import 'package:flutter/material.dart';
import 'package:citizenone_app/components/shared/section_header.dart';
import 'package:citizenone_app/components/shared/service_grid_row.dart';
import 'package:citizenone_app/components/shared/service_section_card.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';

class BankingServiceSection extends StatelessWidget {
  final String title;
  final List<SvcItem> items;

  const BankingServiceSection({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    final rows = _chunk(items, 4);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: title),
        ServiceSectionCard(
          title: '',
          child: Column(
            children: [
              for (var i = 0; i < rows.length; i++) ...[
                ServiceGridRow(items: rows[i]),
                if (i != rows.length - 1) SizedBox(height: tokens.spacingMd),
              ],
            ],
          ),
        ),
      ],
    );
  }

  List<List<SvcItem>> _chunk(List<SvcItem> source, int size) {
    final result = <List<SvcItem>>[];
    for (var i = 0; i < source.length; i += size) {
      final row = source.skip(i).take(size).toList();
      while (row.length < size) {
        row.add(
          const SvcItem(icon: null, label: '', color: Colors.transparent),
        );
      }
      result.add(row);
    }
    return result;
  }
}

// Lists removed - now defined in BankingScreen build() using tokens.
