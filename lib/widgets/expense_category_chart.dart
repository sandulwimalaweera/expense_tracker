import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/expense.dart';

const _categoryColors = [
  Color(0xFF1E3A8A),
  Color(0xFF2563EB),
  Color(0xFF0F766E),
  Color(0xFF38BDF8),
  Color(0xFF64748B),
  Color(0xFF7C3AED),
  Color(0xFFF59E0B),
];

class ExpenseCategoryChart extends StatelessWidget {
  final List<Expense> expenses;

  const ExpenseCategoryChart({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    final categoryTotals = _calculateCategoryTotals();

    if (categoryTotals.isEmpty) {
      return const SizedBox.shrink();
    }

    final entries = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final total = entries.fold<double>(0, (sum, entry) => sum + entry.value);

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
                  Icons.pie_chart_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 10),
                Text(
                  'Spending by Category',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 220,
              child: PieChart(
                PieChartData(
                  centerSpaceRadius: 48,
                  sectionsSpace: 3,
                  sections: entries.asMap().entries.map((entry) {
                    final index = entry.key;
                    final amount = entry.value.value;
                    final percentage = amount / total * 100;

                    return PieChartSectionData(
                      value: amount,
                      color: _categoryColors[index % _categoryColors.length],
                      title: '${percentage.toStringAsFixed(0)}%',
                      radius: 82,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 12),
            ...entries.asMap().entries.map((entry) {
              final index = entry.key;
              final category = entry.value.key;
              final amount = entry.value.value;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _categoryColors[index % _categoryColors.length],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        category,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      'Rs. ${amount.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }),
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
