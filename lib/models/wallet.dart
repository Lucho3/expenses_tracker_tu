import 'package:uuid/uuid.dart';

const uuid = Uuid();
class Wallet {
  final String id;
  final String title;
  final double amount;

  Wallet({
    required this.title,
    required this.amount,
  }) : id = uuid.v4();
}