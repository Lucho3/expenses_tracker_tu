import 'package:uuid/uuid.dart';

const uuid = Uuid();
class Wallet {
  String id;
  String title;
  double amount;
  bool isSelected;


  Wallet({
    required this.title,
    required this.amount,
    required this.isSelected,
  }) : id = uuid.v4();
}