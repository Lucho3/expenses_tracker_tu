import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

final formatter = DateFormat.yMd();
const uuid = Uuid();

enum CategoryExpense {
  food,
  travel,
  leisure,
  work,
}

const categoryIcon = {
  CategoryExpense.food: Icons.lunch_dining,
  CategoryExpense.travel: Icons.flight_takeoff,
  CategoryExpense.leisure: Icons.movie,
  CategoryExpense.work: Icons.work,
};

class Expense {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final CategoryExpense category;

  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4();

  String get formattedDate {
    return formatter.format(date);
  }
}

class ExpenseBucket {
  final CategoryExpense category;
  final List<Expense> expenses;
  ExpenseBucket({required this.category, required this.expenses});

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses.where((ex) => ex.category == category).toList();

  double get totalExpenses {
    double sum = 0;

    for (var expense in expenses) {
      sum += expense.amount;
    }

    return sum;
  }
}
