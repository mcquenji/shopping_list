// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shopping_list_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ShoppingListItem _$ShoppingListItemFromJson(Map<String, dynamic> json) {
  return _ShoppingListItem.fromJson(json);
}

/// @nodoc
mixin _$ShoppingListItem {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  int get createdAtTimestamp => throw _privateConstructorUsedError;
  bool get checked => throw _privateConstructorUsedError;
  int? get checkedAtTimestamp => throw _privateConstructorUsedError;
  int? get updatedAtTimestamp => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ShoppingListItemCopyWith<ShoppingListItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShoppingListItemCopyWith<$Res> {
  factory $ShoppingListItemCopyWith(
          ShoppingListItem value, $Res Function(ShoppingListItem) then) =
      _$ShoppingListItemCopyWithImpl<$Res, ShoppingListItem>;
  @useResult
  $Res call(
      {String id,
      String name,
      int quantity,
      int createdAtTimestamp,
      bool checked,
      int? checkedAtTimestamp,
      int? updatedAtTimestamp});
}

/// @nodoc
class _$ShoppingListItemCopyWithImpl<$Res, $Val extends ShoppingListItem>
    implements $ShoppingListItemCopyWith<$Res> {
  _$ShoppingListItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? quantity = null,
    Object? createdAtTimestamp = null,
    Object? checked = null,
    Object? checkedAtTimestamp = freezed,
    Object? updatedAtTimestamp = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      createdAtTimestamp: null == createdAtTimestamp
          ? _value.createdAtTimestamp
          : createdAtTimestamp // ignore: cast_nullable_to_non_nullable
              as int,
      checked: null == checked
          ? _value.checked
          : checked // ignore: cast_nullable_to_non_nullable
              as bool,
      checkedAtTimestamp: freezed == checkedAtTimestamp
          ? _value.checkedAtTimestamp
          : checkedAtTimestamp // ignore: cast_nullable_to_non_nullable
              as int?,
      updatedAtTimestamp: freezed == updatedAtTimestamp
          ? _value.updatedAtTimestamp
          : updatedAtTimestamp // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShoppingListItemImplCopyWith<$Res>
    implements $ShoppingListItemCopyWith<$Res> {
  factory _$$ShoppingListItemImplCopyWith(_$ShoppingListItemImpl value,
          $Res Function(_$ShoppingListItemImpl) then) =
      __$$ShoppingListItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      int quantity,
      int createdAtTimestamp,
      bool checked,
      int? checkedAtTimestamp,
      int? updatedAtTimestamp});
}

/// @nodoc
class __$$ShoppingListItemImplCopyWithImpl<$Res>
    extends _$ShoppingListItemCopyWithImpl<$Res, _$ShoppingListItemImpl>
    implements _$$ShoppingListItemImplCopyWith<$Res> {
  __$$ShoppingListItemImplCopyWithImpl(_$ShoppingListItemImpl _value,
      $Res Function(_$ShoppingListItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? quantity = null,
    Object? createdAtTimestamp = null,
    Object? checked = null,
    Object? checkedAtTimestamp = freezed,
    Object? updatedAtTimestamp = freezed,
  }) {
    return _then(_$ShoppingListItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      createdAtTimestamp: null == createdAtTimestamp
          ? _value.createdAtTimestamp
          : createdAtTimestamp // ignore: cast_nullable_to_non_nullable
              as int,
      checked: null == checked
          ? _value.checked
          : checked // ignore: cast_nullable_to_non_nullable
              as bool,
      checkedAtTimestamp: freezed == checkedAtTimestamp
          ? _value.checkedAtTimestamp
          : checkedAtTimestamp // ignore: cast_nullable_to_non_nullable
              as int?,
      updatedAtTimestamp: freezed == updatedAtTimestamp
          ? _value.updatedAtTimestamp
          : updatedAtTimestamp // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ShoppingListItemImpl extends _ShoppingListItem {
  _$ShoppingListItemImpl(
      {required this.id,
      required this.name,
      required this.quantity,
      required this.createdAtTimestamp,
      this.checked = false,
      this.checkedAtTimestamp,
      this.updatedAtTimestamp})
      : super._();

  factory _$ShoppingListItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShoppingListItemImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final int quantity;
  @override
  final int createdAtTimestamp;
  @override
  @JsonKey()
  final bool checked;
  @override
  final int? checkedAtTimestamp;
  @override
  final int? updatedAtTimestamp;

  @override
  String toString() {
    return 'ShoppingListItem(id: $id, name: $name, quantity: $quantity, createdAtTimestamp: $createdAtTimestamp, checked: $checked, checkedAtTimestamp: $checkedAtTimestamp, updatedAtTimestamp: $updatedAtTimestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShoppingListItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.createdAtTimestamp, createdAtTimestamp) ||
                other.createdAtTimestamp == createdAtTimestamp) &&
            (identical(other.checked, checked) || other.checked == checked) &&
            (identical(other.checkedAtTimestamp, checkedAtTimestamp) ||
                other.checkedAtTimestamp == checkedAtTimestamp) &&
            (identical(other.updatedAtTimestamp, updatedAtTimestamp) ||
                other.updatedAtTimestamp == updatedAtTimestamp));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, quantity,
      createdAtTimestamp, checked, checkedAtTimestamp, updatedAtTimestamp);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ShoppingListItemImplCopyWith<_$ShoppingListItemImpl> get copyWith =>
      __$$ShoppingListItemImplCopyWithImpl<_$ShoppingListItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShoppingListItemImplToJson(
      this,
    );
  }
}

abstract class _ShoppingListItem extends ShoppingListItem {
  factory _ShoppingListItem(
      {required final String id,
      required final String name,
      required final int quantity,
      required final int createdAtTimestamp,
      final bool checked,
      final int? checkedAtTimestamp,
      final int? updatedAtTimestamp}) = _$ShoppingListItemImpl;
  _ShoppingListItem._() : super._();

  factory _ShoppingListItem.fromJson(Map<String, dynamic> json) =
      _$ShoppingListItemImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  int get quantity;
  @override
  int get createdAtTimestamp;
  @override
  bool get checked;
  @override
  int? get checkedAtTimestamp;
  @override
  int? get updatedAtTimestamp;
  @override
  @JsonKey(ignore: true)
  _$$ShoppingListItemImplCopyWith<_$ShoppingListItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
