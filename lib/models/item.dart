import 'package:expenses_tracker_tu/models/wallet.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

final formatter = DateFormat.yMd();
const uuid = Uuid();


abstract class ItemModel {
  String id;
  String title;
  double amount;
  DateTime date;
  Wallet wallet;

  ItemModel({
    required this.title,
    required this.amount,
    required this.date,
    required this.wallet
  }) : id = uuid.v4();

  String get formattedDate {
    return formatter.format(date);
  }
}


