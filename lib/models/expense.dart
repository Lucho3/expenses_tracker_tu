import 'package:expenses_tracker_tu/models/item.dart';
import 'package:expenses_tracker_tu/models/wallet.dart';
import 'package:flutter/material.dart';

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

class Expense extends ItemModel {
  CategoryExpense category;

  Expense({
    required String title,
    required double amount,
    required DateTime date,
    required Wallet wallet,
    required this.category,
  }) : super(
          title: title,
          amount: amount,
          date: date,
          wallet: wallet,
        );
}
