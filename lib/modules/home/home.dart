import 'package:flutter_modular/flutter_modular.dart';
import 'package:mcquenji_core/mcquenji_core.dart';
import 'package:mcquenji_firebase/mcquenji_firebase.dart';
import 'package:shopping_list/modules/app/app.dart';
import 'package:shopping_list/modules/auth/auth.dart';
import 'package:shopping_list/modules/home/home.dart';
import 'package:shopping_list/modules/home/impl/datasources/datasources.dart';

export 'presentation/presentation.dart';
export 'domain/domain.dart';

class HomeModule extends Module {
  @override
  List<Module> get imports => [
        FirebaseFirestoreModule(),
        FirebaseAuthModule(),
        AuthModule(),
      ];

  @override
  void binds(Injector i) {
    i.addLazySingleton<TypedFirebaseFirestoreDataSource<ShoppingList>>(
      ShoppingListsDataSource.new,
    );

    i.addLazySingleton<TypedFirebaseFirestoreDataSource<ShoppingListItem>>(
      ShoppingListItemsDatasource.new,
    );

    i.addLazySingleton<ShoppingListsRepository>(
      ShoppingListsRepository.new,
      config: cubitConfig<ShoppingListsRepository>(),
    );
    i.addLazySingleton<ShoppingListItemsRepository>(
      ShoppingListItemsRepository.new,
      config: cubitConfig<ShoppingListItemsRepository>(),
    );
  }

  @override
  void routes(RouteManager r) {
    r.child(
      "/",
      customTransition: kDefaultPageTransition,
      child: (_) => const HomeScreen(),
    );

    r.child(
      "/:id",
      customTransition: kDefaultPageTransition,
      child: (_) => ShoppingListItemsScreen(
        id: r.args.params["id"],
      ),
    );
  }
}
