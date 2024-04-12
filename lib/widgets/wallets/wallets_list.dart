import 'package:expenses_tracker_tu/models/wallet.dart';
import 'package:expenses_tracker_tu/widgets/wallets/wallet_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WalletsList extends StatelessWidget {
  WalletsList({super.key, required this.items});

  List<Wallet> items;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (ctx, index) => WalletItem(items[index]),
      ),
    );
  }
}
