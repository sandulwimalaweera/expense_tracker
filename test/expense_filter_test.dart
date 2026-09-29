import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/utils/expense_filter.dart';

void main() {
  final expenses = [
    Expense(
      id: 'today',
      title: 'Lunch',
      amount: 12,
      category: 'Food',
      date: DateTime(2026, 9, 28),
    ),
    Expense(
      id: 'earlier',
      title: 'Bus fare',
      amount: 5,
      category: 'Transport',
      date: DateTime(2026, 8, 15),
    ),
  ];

  test('All Time includes expenses from every date', () {
    final filtered = ExpenseFilter.filter(
      expenses: expenses,
      filterType: 'All Time',
      selectedDate: DateTime(2026, 9, 28),
      selectedMonth: DateTime(2026, 9),
      selectedCategory: 'All',
    );

    expect(filtered.map((expense) => expense.id), ['today', 'earlier']);
  });

  test('All Time still honors category and search filters', () {
    final filtered = ExpenseFilter.filter(
      expenses: expenses,
      filterType: 'All Time',
      selectedDate: DateTime(2026, 9, 28),
      selectedMonth: DateTime(2026, 9),
      selectedCategory: 'Transport',
    );

    expect(filtered.map((expense) => expense.id), ['earlier']);
  });
}
