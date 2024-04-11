import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expenses_tracker_tu/models/item.dart';

abstract class ItemNotifier<T extends ItemModel> extends Notifier<List<T>> {
  @override
  List<T> build();

  List<T> get items;

  void addItem(T item);

  void deleteItem(T item);
}