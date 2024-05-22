import 'package:mcquenji_firebase/mcquenji_firebase.dart';
import 'package:shopping_list/modules/home/home.dart';

class ShoppingListsDataSource
    extends TypedFirebaseFirestoreDataSource<ShoppingList> {
  ShoppingListsDataSource({required super.db}) : super(collectionPath: "lists");

  @override
  ShoppingList deserialize(Map<String, dynamic> data) =>
      ShoppingList.fromJson(data);

  @override
  Map<String, dynamic> serialize(ShoppingList data) => data.toJson();
}
