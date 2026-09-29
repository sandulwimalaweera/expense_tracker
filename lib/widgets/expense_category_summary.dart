import 'package:flutter/material.dart';

import '../models/expense.dart';

class ExpenseCategorySummary extends StatelessWidget {
  final List<Expense> expenses;

  const ExpenseCategorySummary({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    final categoryTotals = _calculateCategoryTotals();

    if (categoryTotals.isEmpty) {
      return const SizedBox.shrink();
    }

    final sortedCategories = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.category_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 10),
                Text(
                  'Category Summary',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...sortedCategories.map(
              (entry) => _CategoryRow(category: entry.key, amount: entry.value),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, double> _calculateCategoryTotals() {
    final totals = <String, double>{};

    for (final expense in expenses) {
      totals.update(
        expense.category,
        (currentTotal) => currentTotal + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }

    return totals;
  }
}

class _CategoryRow extends StatelessWidget {
  final String category;
  final double amount;

  const _CategoryRow({required this.category, required this.amount});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              category,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            'Rs. ${amount.toStringAsFixed(2)}',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
