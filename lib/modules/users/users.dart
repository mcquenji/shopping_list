export 'domain/domain.dart';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:mcquenji_firebase/mcquenji_firebase.dart';
import 'package:shopping_list/modules/users/impl/datasources/users_datasource.dart';
import 'package:shopping_list/modules/users/users.dart';

class UsersModule extends Module {
  @override
  List<Module> get imports => [
        FirebaseAuthModule(),
        FirebaseFirestoreModule(),
      ];

  @override
  void exportedBinds(Injector i) {
    i.addLazySingleton<TypedFirebaseFirestoreDataSource<User>>(
      UsersDataSource.new,
    );
  }

  @override
  void routes(RouteManager r) {}
}
