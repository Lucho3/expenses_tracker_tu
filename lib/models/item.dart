
import 'package:expenses_tracker_tu/models/wallet.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

abstract class ItemModel {
  String title;
  double amount;
  DateTime date;
  Wallet wallet;

  ItemModel({
    required this.title,
    required this.amount,
    required this.date,
    required this.wallet,
  });

  String get formattedDate {
    return formatter.format(date);
  }
}
