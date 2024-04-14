import 'package:expenses_tracker_tu/models/item.dart';
import 'package:expenses_tracker_tu/models/wallet.dart';
import 'package:flutter/material.dart';
import 'package:floor/floor.dart';

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

@entity
class Expense extends ItemModel {
  @PrimaryKey(autoGenerate: true)
  int? id;

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