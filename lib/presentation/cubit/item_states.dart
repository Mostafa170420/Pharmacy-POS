import '../../data/models/item.dart';

abstract class ItemState {}

class ItemInitial extends ItemState {}

class ItemLoading extends ItemState {}

class ItemLoaded extends ItemState {
  final List<Item> items;
  final isOnline;
  ItemLoaded(this.items, this.isOnline);
}

class ItemError extends ItemState {
  final String message;
  ItemError(this.message);
}
