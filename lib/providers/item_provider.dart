import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expenses_tracker_tu/models/item.dart';

abstract class ItemNotifier<T extends ItemModel> extends AsyncNotifier<List<T>> {
  @override
  Future<List<T>> build();

  AsyncValue<List<T>> get items;

  Future<void> addItem(T item);

  Future<void> deleteItem(T item);

  Future<void> editItem(T item);

  Future<void> deleteItemByWalletId(int walletId);
}