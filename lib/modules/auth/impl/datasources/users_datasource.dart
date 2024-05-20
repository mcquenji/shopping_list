import 'package:mcquenji_firebase/mcquenji_firebase.dart';
import 'package:shopping_list/modules/auth/auth.dart';

class UsersDataSource extends TypedFirebaseFirestoreDataSource<User> {
  UsersDataSource({required super.db}) : super(collectionPath: "users");

  @override
  User deserialize(Map<String, dynamic> data) => User.fromJson(data);

  @override
  Map<String, dynamic> serialize(User data) => data.toJson();
}
