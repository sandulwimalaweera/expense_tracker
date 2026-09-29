import 'package:flutter/material.dart';

import '../utils/date_utils.dart';

class ExpenseFilterBar extends StatelessWidget {
  final String filterType;
  final DateTime selectedDate;
  final DateTime selectedMonth;
  final String selectedCategory;
  final List<String> categories;

  final VoidCallback onSelectDate;
  final VoidCallback onSelectMonth;
  final ValueChanged<String> onFilterTypeChanged;
  final ValueChanged<String> onCategoryChanged;

  const ExpenseFilterBar({
    super.key,
    required this.filterType,
    required this.selectedDate,
    required this.selectedMonth,
    required this.selectedCategory,
    required this.categories,
    required this.onSelectDate,
    required this.onSelectMonth,
    required this.onFilterTypeChanged,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFilterTypeSelector(context),
        _buildDateSelector(context),
        _buildCategorySelector(context),
      ],
    );
  }

  Widget _buildFilterTypeSelector(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      child: SegmentedButton<String>(
        segments: const [
          ButtonSegment<String>(
            value: 'All Time',
            label: Text('All Time'),
            icon: Icon(Icons.all_inclusive),
          ),
          ButtonSegment<String>(
            value: 'Date',
            label: Text('Date'),
            icon: Icon(Icons.calendar_today_outlined),
          ),
          ButtonSegment<String>(
            value: 'Month',
            label: Text('Month'),
            icon: Icon(Icons.calendar_month_outlined),
          ),
        ],
        selected: {filterType},
        onSelectionChanged: (selection) {
          onFilterTypeChanged(selection.first);
        },
      ),
    );
  }

  Widget _buildDateSelector(BuildContext context) {
    if (filterType == 'All Time') {
      return const SizedBox.shrink();
    }

    final isDateFilter = filterType == 'Date';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
      child: OutlinedButton.icon(
        onPressed: isDateFilter ? onSelectDate : onSelectMonth,
        icon: Icon(
          isDateFilter
              ? Icons.calendar_today_outlined
              : Icons.calendar_month_outlined,
        ),
        label: Text(
          isDateFilter
              ? DateUtilsHelper.formatDate(selectedDate)
              : '${DateUtilsHelper.getMonthName(selectedMonth.month)} '
                    '${selectedMonth.year}',
        ),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySelector(BuildContext context) {
    return SizedBox(
      height: 54,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 2, 16, 8),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(category),
              selected: selectedCategory == category,
              onSelected: (_) {
                onCategoryChanged(category);
              },
            ),
          );
        },
      ),
    );
  }
}
