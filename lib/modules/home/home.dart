import 'package:flutter_modular/flutter_modular.dart';
import 'package:mcquenji_core/mcquenji_core.dart';
import 'package:mcquenji_firebase/mcquenji_firebase.dart';
import 'package:shopping_list/modules/home/home.dart';
import 'package:shopping_list/modules/home/impl/shopping_lists_datasource.dart';

export 'presentation/presentation.dart';
export 'domain/domain.dart';

class HomeModule extends Module {
  @override
  List<Module> get imports => [
        FirebaseFirestoreModule(),
        FirebaseAuthModule(),
      ];

  @override
  void binds(Injector i) {
    i.addLazySingleton<TypedFirebaseFirestoreDataSource<ShoppingList>>(
      ShoppingListsDataSource.new,
    );

    i.addLazySingleton<ShoppingListsRepository>(
      ShoppingListsRepository.new,
      config: cubitConfig<ShoppingListsRepository>(),
    );
  }

  @override
  void routes(RouteManager r) {
    r.child(
      "/",
      child: (_) => const HomeScreen(),
    );
  }
}
