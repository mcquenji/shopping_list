import 'package:mcquenji_firebase/mcquenji_firebase.dart';
import 'package:shopping_list/modules/home/home.dart';

class ShoppingListItemsDatasource
    extends TypedFirebaseFirestoreDataSource<ShoppingListItem> {
  ShoppingListItemsDatasource({required super.db})
      : super(collectionPath: "lists");

  @override
  ShoppingListItem deserialize(Map<String, dynamic> data) =>
      ShoppingListItem.fromJson(data);

  @override
  Map<String, dynamic> serialize(ShoppingListItem data) => data.toJson();
}
