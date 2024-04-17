import 'package:expenses_tracker_tu/models/converters/datetimeConverter.dart';
import 'package:expenses_tracker_tu/models/item.dart';
import 'package:expenses_tracker_tu/models/wallet.dart';
import 'package:floor/floor.dart';
import 'package:flutter/material.dart';


const categoryIcon = {
  CategoryExpense.food: Icons.lunch_dining,
  CategoryExpense.travel: Icons.flight_takeoff,
  CategoryExpense.leisure: Icons.movie,
  CategoryExpense.work: Icons.work,
};

enum CategoryExpense {
  food,
  travel,
  leisure,
  work,
}

@TypeConverters([DateTimeConverter])
@Entity(tableName: 'expenses', foreignKeys: [
  ForeignKey(entity: Wallet, parentColumns: ['id'], childColumns: ['walletId'])
])
class Expense extends ItemModel {
  @PrimaryKey(autoGenerate: true)
  int? id;

  CategoryExpense category;

  Expense({
    this.id,
    required super.title,
    required super.amount,
    required super.date,
    required super.walletId,
    required this.category,
  });
}
