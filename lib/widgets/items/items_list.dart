
import 'package:expenses_tracker_tu/models/item.dart';
import 'package:expenses_tracker_tu/widgets/items/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class ItemList extends ConsumerWidget {
  const ItemList({super.key, required this.onRemoveItem, required this.items});
  final List<ItemModel> items;
  final void Function(ItemModel item) onRemoveItem ;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
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
          onDismissed: (direction) => onRemoveItem(items[index]),
          child: Item(items[index])),
    );
  }
}
