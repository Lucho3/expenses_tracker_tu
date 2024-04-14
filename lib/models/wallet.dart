import 'package:floor/floor.dart';

@Entity(tableName: 'wallets')
class Wallet {
  @PrimaryKey(autoGenerate: true)
  int? id;

  String title;
  double amount;
  bool isSelected;

  Wallet({
    required this.title,
    required this.amount,
    required this.isSelected,
  });
}