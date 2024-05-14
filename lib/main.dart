import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shopping_list/config/general.dart';
import 'package:shopping_list/modules/app/app.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  if (kDebugMode) {
    FirebaseFirestore.instance.useFirestoreEmulator("localhost", 8080);
    FirebaseFirestore.instance.useFirestoreEmulator("localhost", 9099);
  }

  runApp(
    ModularApp(
      module: AppModule(),
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp.router(
      title: kAppName,
      routerConfig: Modular.routerConfig,
    );
  }
}
