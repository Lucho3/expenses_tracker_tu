import 'package:floor/floor.dart';

@Entity(tableName: 'wallets')
class Wallet {
  @PrimaryKey(autoGenerate: true)
  int? id;

  String title;
  double amount;
  bool isSelected;

  Wallet({
    this.id,
    required this.title,
    required this.amount,
    required this.isSelected,
  });

  Wallet copyWith({
    int? id,
    String? title,
    double? amount,
    bool? isSelected,
  }) {
    return Wallet(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}