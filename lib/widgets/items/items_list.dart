
import 'package:expenses_tracker_tu/models/item.dart';
import 'package:expenses_tracker_tu/providers/item_provider.dart';
import 'package:expenses_tracker_tu/providers/wallets_provider.dart';
import 'package:expenses_tracker_tu/widgets/items/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class ItemList extends ConsumerWidget {
  ItemList({super.key, required this.onRemoveItem, required this.provider});
  
  NotifierProvider<ItemNotifier<ItemModel>, List<ItemModel>> provider;
  final void Function(ItemModel item) onRemoveItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //TODO do with real wallet
    final selectedWallet = ref.read(walletsProvider.notifier).items.where((w) => w.isSelected == true).first;
    final items = ref.watch(provider).where((item) => item.wallet == selectedWallet).toList();
    return ListView.builder(
      // Item count sets the maximum number of return widgets
      itemCount: items.length,
      itemBuilder: (ctx, index) => Dismissible(
          background: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: Theme.of(context).colorScheme.error.withOpacity(0.65),
            ),
            margin: EdgeInsets.symmetric(
                horizontal: Theme.of(context).cardTheme.margin!.horizontal),
          ),
          key: ValueKey(items[index]),
          //from provider
          onDismissed: (direction) => onRemoveItem(items[index]),
          child: Item(items[index])),
    );
  }
}
