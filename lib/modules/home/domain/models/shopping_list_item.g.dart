// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_list_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShoppingListItemImpl _$$ShoppingListItemImplFromJson(
        Map<String, dynamic> json) =>
    _$ShoppingListItemImpl(
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toInt(),
      checked: json['checked'] as bool,
    );

Map<String, dynamic> _$$ShoppingListItemImplToJson(
        _$ShoppingListItemImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'quantity': instance.quantity,
      'checked': instance.checked,
    };
