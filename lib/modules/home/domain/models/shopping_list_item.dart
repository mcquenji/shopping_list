import 'package:freezed_annotation/freezed_annotation.dart';

part 'shopping_list_item.freezed.dart';
part 'shopping_list_item.g.dart';

@freezed
class ShoppingListItem with _$ShoppingListItem {
  factory ShoppingListItem({
    required String name,
    required int quantity,
    required bool checked,
  }) = _ShoppingListItem;

  factory ShoppingListItem.fromJson(Map<String, dynamic> json) =>
      _$ShoppingListItemFromJson(json);
}
