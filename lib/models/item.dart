
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

abstract class ItemModel {
  String title;
  double amount;
  DateTime date;

  int walletId;

  ItemModel({
    required this.title,
    required this.amount,
    required this.date,
    required this.walletId,
  });

  String get formattedDate {
    return formatter.format(date);
  }
}
