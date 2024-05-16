import 'package:flutter_modular/flutter_modular.dart';
import 'package:mcquenji_core/mcquenji_core.dart';
import 'package:mcquenji_firebase/mcquenji_firebase.dart';
import 'package:shopping_list/modules/app/app.dart';
import 'package:shopping_list/modules/auth/presentation/presentation.dart';
import 'package:shopping_list/modules/users/users.dart';

export 'domain/domain.dart';
export 'presentation/presentation.dart';

class AuthModule extends Module {
  @override
  List<Module> get imports => [
        FirebaseAuthModule(),
        UsersModule(),
      ];

  @override
  void binds(Injector i) {
    i.addLazySingleton<UserRepository>(
      UserRepository.new,
      config: cubitConfig(),
    );
  }

  @override
  void exportedBinds(Injector i) {}

  @override
  void routes(RouteManager r) {
    r.child(
      "/",
      child: (_) {
        return const LoginScreen();
      },
      customTransition: kDefaultPageTransition,
      guards: [OfflineGuard()],
    );

    r.child(
      "/complete-profile",
      child: (_) => const CompleteProfileScreen(),
      guards: [
        OfflineGuard(),
        FirebaseAuthGuard(redirectTo: "/auth"),
      ],
      customTransition: kDefaultPageTransition,
    );
  }
}
