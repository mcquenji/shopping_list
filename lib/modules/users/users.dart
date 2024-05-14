export 'domain/domain.dart';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:mcquenji_firebase/mcquenji_firebase.dart';
import 'package:shopping_list/modules/users/domain/impl/datasources/users_datasource.dart';
import 'package:shopping_list/modules/users/users.dart';

class UsersModule extends Module {
  @override
  void binds(Injector i) {}

  @override
  void exportedBinds(Injector i) {
    i.addLazySingleton<TypedFirebaseFirestoreDataSource<User>>(
      () => UsersDataSource(
        auth: i.get<FirebaseAuthService>(),
        db: i.get<FirebaseFirestoreDataSource>(),
      ),
    );
  }

  @override
  void routes(RouteManager r) {}
}
