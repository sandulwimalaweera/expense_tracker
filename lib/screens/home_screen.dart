import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../services/expense_service.dart';
import '../utils/date_utils.dart';
import '../utils/error_message.dart';
import '../utils/expense_filter.dart';
import '../widgets/empty_expense_state.dart';
import '../widgets/expense_card.dart';
import '../widgets/expense_category_summary.dart';
import '../widgets/expense_error_state.dart';
import '../widgets/expense_filter_bar.dart';
import '../widgets/expense_summary.dart';
import 'add_expense_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ExpenseService _expenseService = ExpenseService();
  final TextEditingController _searchController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);

  String _filterType = 'All Time';
  String _selectedCategory = 'All';
  String _searchQuery = '';

  final List<String> _categories = [
    'All',
    'Food',
    'Transport',
    'Shopping',
    'Bills',
    'Entertainment',
    'Health',
    'Other',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (selected != null && mounted) {
      setState(() {
        _selectedDate = selected;
      });
    }
  }

  Future<void> _selectMonth() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _selectedMonth,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      helpText: 'Select a month',
    );

    if (selected != null && mounted) {
      setState(() {
        _selectedMonth = DateTime(selected.year, selected.month);
      });
    }
  }

  String _getSummaryTitle() {
    final period = switch (_filterType) {
      'Date' => DateUtilsHelper.formatDate(_selectedDate),
      'Month' =>
        '${DateUtilsHelper.getMonthName(_selectedMonth.month)} '
            '${_selectedMonth.year}',
      _ => 'All Time',
    };

    if (_selectedCategory == 'All') {
      return 'Total for $period';
    }

    return '$_selectedCategory - $period';
  }

  Future<void> _deleteExpense(BuildContext context, Expense expense) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(Icons.delete_outline),
          title: const Text('Delete Expense'),
          content: Text(
            'Are you sure you want to delete '
            '"${expense.title}"? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    try {
      await _expenseService.deleteExpense(expense.id);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Expense deleted successfully'),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(ErrorMessage.from(e)),
        ),
      );
    }
  }

  void _clearSearch() {
    _searchController.clear();

    setState(() {
      _searchQuery = '';
    });
  }

  void _openAddExpense() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
    );
  }

  void _openEditExpense(Expense expense) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddExpenseScreen(expense: expense)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Expense Tracker',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: StreamBuilder<List<Expense>>(
        stream: _expenseService.getExpenses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return ExpenseErrorState(error: snapshot.error!);
          }

          final expenses = snapshot.data ?? [];

          final filteredExpenses = ExpenseFilter.filter(
            expenses: expenses,
            filterType: _filterType,
            selectedDate: _selectedDate,
            selectedMonth: _selectedMonth,
            selectedCategory: _selectedCategory,
            searchQuery: _searchQuery,
          );

          final total = ExpenseFilter.calculateTotal(filteredExpenses);

          return ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.only(bottom: 120),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: _buildSearchField(),
              ),

              if (expenses.isEmpty)
                const EmptyExpenseState()
              else ...[
                ExpenseFilterBar(
                  filterType: _filterType,
                  selectedDate: _selectedDate,
                  selectedMonth: _selectedMonth,
                  selectedCategory: _selectedCategory,
                  categories: _categories,
                  onSelectDate: _selectDate,
                  onSelectMonth: _selectMonth,
                  onFilterTypeChanged: (value) {
                    setState(() {
                      _filterType = value;
                    });
                  },
                  onCategoryChanged: (category) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                ),

                const SizedBox(height: 4),

                ExpenseSummary(
                  title: _getSummaryTitle(),
                  total: total,
                  expenseCount: filteredExpenses.length,
                ),

                ExpenseCategorySummary(expenses: filteredExpenses),

                if (filteredExpenses.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: EmptyExpenseState(),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: filteredExpenses
                          .map(
                            (expense) => ExpenseCard(
                              expense: expense,
                              onEdit: () {
                                _openEditExpense(expense);
                              },
                              onDelete: () {
                                _deleteExpense(context, expense);
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
              ],
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddExpense,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        icon: const Icon(Icons.add),
        label: const Text(
          'Add Expense',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    final colorScheme = Theme.of(context).colorScheme;

    return TextField(
      controller: _searchController,
      textInputAction: TextInputAction.search,
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
      decoration: InputDecoration(
        hintText: 'Search expenses...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _searchQuery.isEmpty
            ? null
            : IconButton(
                onPressed: _clearSearch,
                icon: const Icon(Icons.clear),
                tooltip: 'Clear search',
              ),
        filled: true,
        fillColor: colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
      ),
    );
  }
}
