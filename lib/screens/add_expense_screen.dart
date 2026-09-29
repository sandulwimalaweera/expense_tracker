import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../services/expense_service.dart';
import '../utils/error_message.dart';

class AddExpenseScreen extends StatefulWidget {
  final Expense? expense;

  const AddExpenseScreen({super.key, this.expense});

  bool get isEditing => expense != null;

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  final ExpenseService _expenseService = ExpenseService();

  String _selectedCategory = 'Food';
  DateTime _selectedDate = DateTime.now();
  bool _isSaving = false;

  final List<String> _categories = [
    'Food',
    'Transport',
    'Shopping',
    'Bills',
    'Entertainment',
    'Health',
    'Other',
  ];

  @override
  void initState() {
    super.initState();

    final expense = widget.expense;

    if (expense != null) {
      _titleController.text = expense.title;
      _amountController.text = expense.amount.toStringAsFixed(2);
      _selectedCategory = expense.category;
      _selectedDate = expense.date;
      _noteController.text = expense.note;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && mounted) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _saveExpense() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final expense = Expense(
        id: widget.expense?.id ?? '',
        title: _titleController.text.trim(),
        amount: double.parse(_amountController.text.trim()),
        category: _selectedCategory,
        date: _selectedDate,
        note: _noteController.text.trim(),
      );

      if (widget.isEditing) {
        await _expenseService.updateExpense(expense);
      } else {
        await _expenseService.addExpense(expense);
      }

      if (!mounted) return;

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            widget.isEditing
                ? 'Expense updated successfully'
                : 'Expense added successfully',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(ErrorMessage.from(e)),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  InputDecoration _inputDecoration({
    required String label,
    String? hint,
    IconData? prefixIcon,
    String? prefixText,
    Widget? suffixIcon,
    bool alignLabelWithHint = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
      prefixText: prefixText,
      suffixIcon: suffixIcon,
      alignLabelWithHint: alignLabelWithHint,
      filled: true,
      fillColor: colorScheme.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colorScheme.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colorScheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEditing ? 'Edit Expense' : 'Add Expense',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          children: [
            Text(
              widget.isEditing
                  ? 'Update your expense details'
                  : 'Enter your expense details',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 20),

            // Title
            TextFormField(
              controller: _titleController,
              textInputAction: TextInputAction.next,
              enabled: !_isSaving,
              decoration: _inputDecoration(
                label: 'Title',
                hint: 'e.g. Lunch',
                prefixIcon: Icons.title_outlined,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a title';
                }

                if (value.trim().length < 2) {
                  return 'Title must be at least 2 characters';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            // Amount
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textInputAction: TextInputAction.next,
              enabled: !_isSaving,
              decoration: _inputDecoration(
                label: 'Amount',
                hint: 'e.g. 1500.00',
                prefixText: 'Rs. ',
                prefixIcon: Icons.payments_outlined,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter an amount';
                }

                final amount = double.tryParse(value.trim());

                if (amount == null) {
                  return 'Please enter a valid amount';
                }

                if (amount <= 0) {
                  return 'Amount must be greater than 0';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            // Category
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              decoration: _inputDecoration(
                label: 'Category',
                prefixIcon: Icons.category_outlined,
              ),
              items: _categories.map((category) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),
              onChanged: _isSaving
                  ? null
                  : (value) {
                      if (value != null) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      }
                    },
            ),

            const SizedBox(height: 16),

            // Date
            InkWell(
              onTap: _isSaving ? null : _selectDate,
              borderRadius: BorderRadius.circular(14),
              child: InputDecorator(
                decoration: _inputDecoration(
                  label: 'Date',
                  prefixIcon: Icons.calendar_today_outlined,
                  suffixIcon: const Icon(Icons.arrow_drop_down),
                ),
                child: Text(
                  _formatDate(_selectedDate),
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Note
            TextFormField(
              controller: _noteController,
              maxLines: 3,
              textInputAction: TextInputAction.done,
              enabled: !_isSaving,
              decoration: _inputDecoration(
                label: 'Note (Optional)',
                hint: 'Add a description...',
                prefixIcon: Icons.notes_outlined,
                alignLabelWithHint: true,
              ),
            ),

            const SizedBox(height: 28),

            // Save button
            SizedBox(
              height: 54,
              child: FilledButton.icon(
                onPressed: _isSaving ? null : _saveExpense,
                icon: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(widget.isEditing ? Icons.save_outlined : Icons.add),
                label: Text(
                  _isSaving
                      ? 'Saving...'
                      : widget.isEditing
                      ? 'Update Expense'
                      : 'Save Expense',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            Text(
              'All fields except the note are required.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
