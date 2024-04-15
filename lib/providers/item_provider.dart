import 'package:expenses_tracker_tu/models/wallet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expenses_tracker_tu/models/item.dart';

abstract class ItemNotifier<T extends ItemModel> extends AsyncNotifier<List<T>> {
  @override
  Future<List<T>> build();

  AsyncValue<List<T>> get items;

  void addItem(T item);

  void deleteItem(T item);

  void editItem(T item);
}