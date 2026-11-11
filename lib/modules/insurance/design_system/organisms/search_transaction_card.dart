import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';

class SearchTransactionCard extends StatelessWidget {
  final TextEditingController searchController;
  final DateTime? fromDate;
  final DateTime? toDate;
  final VoidCallback onFromTap;
  final VoidCallback onToTap;
  final ValueChanged<String>? onSearch;

  const SearchTransactionCard({
    super.key,
    required this.searchController,
    required this.fromDate,
    required this.toDate,
    required this.onFromTap,
    required this.onToTap,
    this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: AppColors.surfaceBg,
            blurRadius: 3,
            spreadRadius: 1,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20,24,17,19),
            child: TextField(
              controller: searchController,
              onChanged: onSearch,
              decoration: InputDecoration(
                hintText: 'Search Ref No, Name, Status...',
                hintStyle: const TextStyle(color: AppColors.labelGrey),
                prefixIcon: const Icon(Icons.search),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.border)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20,right: 17,bottom: 24),
            child: Row(
              children: [
                Expanded(
                  child: _DateField(
                    title: 'From Date',
                    date: fromDate,
                    onTap: onFromTap,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _DateField(
                    title: 'To Date',
                    date: toDate,
                    onTap: onToTap,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  final String title;
  final DateTime? date;
  final VoidCallback onTap;

  const _DateField({
    required this.title,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    date == null
                        ? 'YYYY-MM-DD'
                        : DateFormat('yyyy-MM-dd').format(date!),
                    style: const TextStyle(
                      color: AppColors.labelGrey,
                      fontSize: 15,
                    ),
                  ),
                ),
                const Icon(Icons.calendar_today_outlined, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
