import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shopping_list/modules/app/app.dart';
import 'package:shopping_list/modules/auth/auth.dart';
import 'package:shopping_list/utils.dart';

class CompleteProfileScreen extends StatelessWidget {
  const CompleteProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var user = context.watch<UserRepository>();

    return user.state.when(
      data: (data) {
        if (data!.name.isNotEmpty) {
          Modular.to.navigate('/');
        }

        return const CupertinoPageScaffold(
          backgroundColor: CupertinoColors.systemGroupedBackground,
          child: SafeArea(
            child: CompleteProfileForm(),
          ),
        );
      },
      loading: () => const CupertinoActivityIndicator().large(context),
      error: UnexpectedErrorWidget.handler,
    );
  }
}
