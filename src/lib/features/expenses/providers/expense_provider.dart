import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/expense_model.dart';

class ExpensesProvider extends ChangeNotifier {
  List<ExpenseModel> _expenses = [];
  bool _isLoading = false;
  String? _error;

  List<ExpenseModel> get expenses => _expenses;
  bool get isLoading => _isLoading;
  String? get error => _error;

  double get totalExpenses {
    return _expenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  Future<void> fetchExpenses() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final userId = Supabase.instance.client.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final response = await Supabase.instance.client
          .from('expenses')
          .select()
          .eq('user_id', userId)
          .order('expense_date', ascending: false);

      _expenses = (response as List)
          .map((json) => ExpenseModel.fromJson(json))
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createExpense({
    required String title,
    required double amount,
    required ExpenseCategory category,
    required DateTime expenseDate,
  }) async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('User not authenticated');
      }

      await Supabase.instance.client.from('expenses').insert({
        'user_id': userId,
        'title': title,
        'amount': amount,
        'category': category.displayName,
        'expense_date': expenseDate.toIso8601String(),
      });

      await fetchExpenses();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateExpense({
    required String id,
    required String title,
    required double amount,
    required ExpenseCategory category,
    required DateTime expenseDate,
  }) async {
    try {
      await Supabase.instance.client.from('expenses').update({
        'title': title,
        'amount': amount,
        'category': category.displayName,
        'expense_date': expenseDate.toIso8601String(),
      }).eq('id', id);

      await fetchExpenses();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteExpense(String id) async {
    try {
      await Supabase.instance.client.from('expenses').delete().eq('id', id);

      await fetchExpenses();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}
