import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mcquenji_core/mcquenji_core.dart';
import 'package:mcquenji_firebase/mcquenji_firebase.dart';

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
    r.child(
      "/",
      child: (_) => Container(),
    );
  }
}
