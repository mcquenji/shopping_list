import 'package:freezed_annotation/freezed_annotation.dart';

part 'shopping_list_item.freezed.dart';
part 'shopping_list_item.g.dart';

@freezed
class ShoppingListItem with _$ShoppingListItem {
  const ShoppingListItem._();

  factory ShoppingListItem({
    required String id,
    required String name,
    required int quantity,
    required int createdAtTimestamp,
    @Default(false) bool checked,
    int? checkedAtTimestamp,
    int? updatedAtTimestamp,
    String? buyerId,
  }) = _ShoppingListItem;

  DateTime get createdAt => DateTime.fromMillisecondsSinceEpoch(
        createdAtTimestamp,
      );

  DateTime? get checkedAt => checkedAtTimestamp == null
      ? null
      : DateTime.fromMillisecondsSinceEpoch(checkedAtTimestamp!);

  DateTime? get updatedAt => updatedAtTimestamp == null
      ? null
      : DateTime.fromMillisecondsSinceEpoch(updatedAtTimestamp!);

  factory ShoppingListItem.fromJson(Map<String, dynamic> json) =>
      _$ShoppingListItemFromJson(json);
}
