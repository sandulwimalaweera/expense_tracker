import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../services/expense_service.dart';
import '../utils/error_message.dart';
import '../utils/expense_filter.dart';
import '../widgets/expense_category_chart.dart';
import '../widgets/expense_category_summary.dart';
import '../widgets/expense_summary.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final ExpenseService _expenseService = ExpenseService();

  String _filterType = 'This Month';

  List<Expense> _filterExpenses(List<Expense> expenses) {
    if (_filterType == 'All Time') {
      return expenses;
    }

    final now = DateTime.now();

    return expenses.where((expense) {
      return expense.date.year == now.year && expense.date.month == now.month;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body: StreamBuilder<List<Expense>>(
        stream: _expenseService.getExpenses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 56),
                    const SizedBox(height: 16),
                    const Text(
                      'Unable to load statistics',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ErrorMessage.from(snapshot.error!),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          final expenses = snapshot.data ?? [];

          if (expenses.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bar_chart_outlined, size: 64),
                    SizedBox(height: 16),
                    Text(
                      'No statistics yet',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Add some expenses to see your spending statistics.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          final filteredExpenses = _filterExpenses(expenses);
          final total = ExpenseFilter.calculateTotal(filteredExpenses);

          return ListView(
            padding: const EdgeInsets.only(top: 16, bottom: 32),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SegmentedButton<String>(
                  segments: const [
                    ButtonSegment<String>(
                      value: 'This Month',
                      label: Text('This Month'),
                      icon: Icon(Icons.calendar_month_outlined),
                    ),
                    ButtonSegment<String>(
                      value: 'All Time',
                      label: Text('All Time'),
                      icon: Icon(Icons.all_inclusive),
                    ),
                  ],
                  selected: {_filterType},
                  onSelectionChanged: (selection) {
                    setState(() {
                      _filterType = selection.first;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              if (filteredExpenses.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      const Icon(Icons.bar_chart_outlined, size: 56),
                      const SizedBox(height: 16),
                      Text(
                        _filterType == 'This Month'
                            ? 'No expenses this month'
                            : 'No expenses found',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _filterType == 'This Month'
                            ? 'Add an expense to start tracking your spending.'
                            : 'Add some expenses to see your statistics.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              else ...[
                ExpenseSummary(
                  title: _filterType == 'This Month'
                      ? 'This Month'
                      : 'All Time',
                  total: total,
                  expenseCount: filteredExpenses.length,
                ),
                ExpenseCategoryChart(expenses: filteredExpenses),
                ExpenseCategorySummary(expenses: filteredExpenses),
              ],
            ],
          );
        },
      ),
    );
  }
}
