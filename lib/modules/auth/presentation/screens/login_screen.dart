import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mcquenji_core/mcquenji_core.dart';
import 'package:mcquenji_firebase/mcquenji_firebase.dart';
import 'package:shopping_list/modules/app/app.dart';
import 'package:shopping_list/modules/auth/auth.dart';
import 'package:shopping_list/utils.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<UserRepository>();
    final users = Modular.get<TypedFirebaseFirestoreDataSource<User>>();

    users.readAll().then((value) {
      if (value.isNotEmpty) return;

      Modular.to.navigate('/auth/register');
    });

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        middle: context.t.login_title.text,
      ),
      child: repo.state.when(
        data: (user) {
          if (user != null) {
            Modular.to.navigate('/');
          }

          return const SafeArea(
            child: LoginForm(),
          );
        },
        loading: () => Center(
          child: const CupertinoActivityIndicator().large(context),
        ),
        error: UnexpectedErrorWidget.handler,
      ),
    );
  }
}
