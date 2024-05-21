import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mcquenji_core/mcquenji_core.dart';
import 'package:mcquenji_firebase/mcquenji_firebase.dart';
import 'package:shopping_list/modules/app/presentation/presentation.dart';
import 'package:shopping_list/modules/auth/auth.dart';
import 'package:shopping_list/modules/home/home.dart';

export 'presentation/presentation.dart';
export 'guards/guards.dart';

class AppModule extends Module {
  @override
  List<Module> get imports => [
        CoreModule(),
        FirebaseAuthModule(),
        FirebaseFirestoreModule(),
      ];

  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.module(
      "/",
      customTransition: kDefaultPageTransition,
      guards: [
        FirebaseAuthGuard(redirectTo: "/auth/"),
      ],
      module: HomeModule(),
    );
    r.child(
      "/offline",
      child: (_) => OfflineScreen(
        from: r.args.queryParams["from"],
      ),
    );

    r.module(
      "/auth",
      customTransition: kDefaultPageTransition,
      module: AuthModule(),
    );
  }
}

final kDefaultPageTransition = CustomTransition(
  transitionBuilder: (context, primary, secondary, child) =>
      CupertinoPageTransition(
    primaryRouteAnimation: primary,
    secondaryRouteAnimation: secondary,
    linearTransition: false,
    child: child,
  ),
);
