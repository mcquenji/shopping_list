// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_list_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShoppingListItemImpl _$$ShoppingListItemImplFromJson(
        Map<String, dynamic> json) =>
    _$ShoppingListItemImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toInt(),
      createdAtTimestamp: (json['createdAtTimestamp'] as num).toInt(),
      checked: json['checked'] as bool? ?? false,
      checkedAtTimestamp: (json['checkedAtTimestamp'] as num?)?.toInt(),
      updatedAtTimestamp: (json['updatedAtTimestamp'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ShoppingListItemImplToJson(
        _$ShoppingListItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'quantity': instance.quantity,
      'createdAtTimestamp': instance.createdAtTimestamp,
      'checked': instance.checked,
      'checkedAtTimestamp': instance.checkedAtTimestamp,
      'updatedAtTimestamp': instance.updatedAtTimestamp,
    };
