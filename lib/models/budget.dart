import 'package:flutter/foundation.dart';

class Budget {
  final String id;
  final String category;
  final double limit;
  double spent;
  final DateTime startDate;
  final DateTime endDate;

  Budget({
    required this.id,
    required this.category,
    required this.limit,
    this.spent = 0.0,
    required this.startDate,
    required this.endDate,
  });

  double get remainingAmount => limit - spent;
  double get spentPercentage => (spent / limit) * 100;
  bool get isOverBudget => spent > limit;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'limit': limit,
      'spent': spent,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'],
      category: json['category'],
      limit: json['limit'],
      spent: json['spent'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
    );
  }
}

class BudgetProvider with ChangeNotifier {
  List<Budget> _budgets = [];

  List<Budget> get budgets => [..._budgets];

  void addBudget(Budget budget) {
    _budgets.add(budget);
    notifyListeners();
  }

  void deleteBudget(String id) {
    _budgets.removeWhere((budget) => budget.id == id);
    notifyListeners();
  }

  void updateBudget(String id, double amount) {
    final budgetIndex = _budgets.indexWhere((b) => b.id == id);
    if (budgetIndex >= 0) {
      _budgets[budgetIndex].spent += amount;
      notifyListeners();
    }
  }

  double getTotalSpent() {
    return _budgets.fold(0, (sum, budget) => sum + budget.spent);
  }

  double getTotalBudget() {
    return _budgets.fold(0, (sum, budget) => sum + budget.limit);
  }
} 