import 'package:flutter_modular/flutter_modular.dart';
import 'package:mcquenji_core/mcquenji_core.dart';
import 'package:mcquenji_firebase/mcquenji_firebase.dart';
import 'package:shopping_list/modules/app/app.dart';
import 'package:shopping_list/modules/auth/auth.dart';
import 'package:shopping_list/modules/auth/impl/impl.dart';

export 'domain/domain.dart';
export 'presentation/presentation.dart';

class AuthModule extends Module {
  @override
  List<Module> get imports => [
        FirebaseAuthModule(),
        FirebaseFirestoreModule(),
      ];

  @override
  void binds(Injector i) {
    i.addLazySingleton<TypedFirebaseFirestoreDataSource<User>>(
      UsersDataSource.new,
    );
    i.addLazySingleton<TypedFirebaseFirestoreDataSource<Referral>>(
      ReferralsDataSource.new,
    );

    i.addLazySingleton<UserRepository>(
      UserRepository.new,
      config: cubitConfig<UserRepository>(),
    );
    i.addLazySingleton<SignUpRepository>(
      SignUpRepository.new,
      config: cubitConfig<SignUpRepository>(),
    );
  }

  @override
  void exportedBinds(Injector i) {}

  @override
  void routes(RouteManager r) {
    r.child(
      "/",
      customTransition: kDefaultPageTransition,
      child: (_) => Online(
        builder: (_) => const LoginScreen(),
      ),
    );

    r.child(
      "/register",
      child: (_) => Online(
        builder: (context) => SignUpScreen(
          referralCode: r.args.queryParams["code"],
        ),
      ),
    );
  }
}
