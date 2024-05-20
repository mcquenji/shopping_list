import 'package:freezed_annotation/freezed_annotation.dart';
import 'shopping_list_item.dart';

part 'shopping_list.freezed.dart';
part 'shopping_list.g.dart';

@freezed
class ShoppingList with _$ShoppingList {
  factory ShoppingList({
    required String id,
    required String name,
    required String owner,
    @Default([]) List<String> members,
    @Default([]) List<ShoppingListItem> items,
  }) = _ShoppingList;

  factory ShoppingList.fromJson(Map<String, dynamic> json) =>
      _$ShoppingListFromJson(json);
}
