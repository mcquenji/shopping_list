import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mcquenji_core/mcquenji_core.dart';
import 'package:mcquenji_firebase/mcquenji_firebase.dart';
import 'package:shopping_list/modules/app/app.dart';
import 'package:shopping_list/modules/auth/auth.dart';
import 'package:shopping_list/utils.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key, this.referralCode});

  final String? referralCode;

  @override
  Widget build(BuildContext context) {
    final referrals = context.watch<SignUpRepository>();
    final users = Modular.get<TypedFirebaseFirestoreDataSource<User>>();

    return CupertinoPageScaffold(
      backgroundColor: CupertinoDynamicColor.resolve(
        CupertinoColors.systemGroupedBackground,
        context,
      ),
      navigationBar: CupertinoNavigationBar(
        leading: context.t.register_title.text,
      ),
      child: SafeArea(
        child: referrals.state.when(
          data: (data) => FutureBuilder(
            future: users.readAll(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: const CupertinoActivityIndicator().large(context),
                );
              }

              if (snapshot.data!.isEmpty) return const SignUpForm();

              final valid = referrals.validateReferralCode(referralCode ?? "");

              if (!valid) return const InvalidReferralCodeWidget();

              return SignUpForm(
                referralCode: referralCode!,
              );
            },
          ),
          loading: () => Center(
            child: const CupertinoActivityIndicator().large(context),
          ),
          error: UnexpectedErrorWidget.handler,
        ),
      ),
    );
  }
}
