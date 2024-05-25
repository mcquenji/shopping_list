import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:logging/logging.dart';
import 'package:mcquenji_core/mcquenji_core.dart';
import 'package:pwa_update_listener/pwa_update_listener.dart';
import 'package:shopping_list/config/firebase.dart';
import 'package:shopping_list/config/general.dart';
import 'package:shopping_list/firebase_options.dart';
import 'package:shopping_list/modules/app/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:shopping_list/utils.dart';

void main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    if (kDebugMode) {
      print(
        "$record ${record.error ?? ""} ${record.stackTrace ?? ""}",
      );
    }
  });

  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );

  assertFirebaseConfigured();

  DeclarativeEdgeInsets.defaultPadding = 20;

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kDebugMode) {
    FirebaseFirestore.instance.useFirestoreEmulator("localhost", 8080);
    FirebaseAuth.instance.useAuthEmulator("localhost", 9099);
  }

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  runApp(
    ModularApp(
      module: AppModule(),
      child: DevicePreview(
        enabled: !kReleaseMode,
        builder: (_) => const App(),
      ),
    ),
  );
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  Brightness get brightness =>
      SchedulerBinding.instance.platformDispatcher.platformBrightness;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );

    super.initState();
    SchedulerBinding.instance.platformDispatcher.onPlatformBrightnessChanged =
        () => setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return PwaUpdateListener(
          onReady: () => showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: context.t.update_title.text,
              content: context.t.update_message.text,
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: context.t.update_btn.text,
                  onPressed: () async {
                    reloadPwa();
                  },
                ),
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  child: context.t.update_later.text,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          child: CupertinoApp.router(
            theme: CupertinoThemeData(
              brightness: brightness,
            ),
            title: kAppName,
            locale: AppLocalizations.supportedLocales.first,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: Modular.routerConfig,
          ),
        );
      },
    );
  }
}
