import '../models/expense.dart';

class ExpenseFilter {
  static List<Expense> filter({
    required List<Expense> expenses,
    required String filterType,
    required DateTime selectedDate,
    required DateTime selectedMonth,
    required String selectedCategory,
    String searchQuery = '',
  }) {
    return expenses.where((expense) {
      final matchesDateOrMonth = _matchesDateOrMonth(
        expense: expense,
        filterType: filterType,
        selectedDate: selectedDate,
        selectedMonth: selectedMonth,
      );

      final matchesCategory =
          selectedCategory == 'All' || expense.category == selectedCategory;

      final matchesSearch = _matchesSearch(
        expense: expense,
        searchQuery: searchQuery,
      );

      return matchesDateOrMonth && matchesCategory && matchesSearch;
    }).toList();
  }

  static bool _matchesDateOrMonth({
    required Expense expense,
    required String filterType,
    required DateTime selectedDate,
    required DateTime selectedMonth,
  }) {
    if (filterType == 'All Time') {
      return true;
    }

    if (filterType == 'Date') {
      return expense.date.year == selectedDate.year &&
          expense.date.month == selectedDate.month &&
          expense.date.day == selectedDate.day;
    }

    return expense.date.year == selectedMonth.year &&
        expense.date.month == selectedMonth.month;
  }

  static bool _matchesSearch({
    required Expense expense,
    required String searchQuery,
  }) {
    if (searchQuery.trim().isEmpty) {
      return true;
    }

    final query = searchQuery.trim().toLowerCase();

    return expense.title.toLowerCase().contains(query) ||
        expense.category.toLowerCase().contains(query) ||
        expense.note.toLowerCase().contains(query);
  }

  static double calculateTotal(List<Expense> expenses) {
    return expenses.fold(0, (total, expense) => total + expense.amount);
  }
}
