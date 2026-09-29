import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/expense.dart';

class ExpenseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _expensesCollection {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User is not authenticated.');
    }

    return _firestore.collection('users').doc(user.uid).collection('expenses');
  }

  // Get all expenses for the current user
  Stream<List<Expense>> getExpenses() {
    return _expensesCollection
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Expense.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  // Add a new expense
  Future<void> addExpense(Expense expense) async {
    await _expensesCollection.add(expense.toMap());
  }

  // Update an existing expense
  Future<void> updateExpense(Expense expense) async {
    await _expensesCollection.doc(expense.id).update(expense.toMap());
  }

  // Delete an expense
  Future<void> deleteExpense(String expenseId) async {
    await _expensesCollection.doc(expenseId).delete();
  }
}
