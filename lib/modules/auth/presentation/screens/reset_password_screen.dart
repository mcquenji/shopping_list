import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mcquenji_core/mcquenji_core.dart';
import 'package:mcquenji_firebase/mcquenji_firebase.dart';
import 'package:shopping_list/modules/auth/auth.dart';
import 'package:shopping_list/utils.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key, required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final auth = context.read<FirebaseAuthService>();

    return FutureBuilder(
      future: code.isEmpty ? null : auth.verifyPasswordResetCode(code),
      builder: (context, snapshot) {
        return CupertinoPageScaffold(
          backgroundColor:
              CupertinoColors.systemGroupedBackground.resolveFrom(context),
          navigationBar: CupertinoNavigationBar(
            middle: context.t.resetPassword_title.text,
          ),
          child: SafeArea(
            child: code.isEmpty || (snapshot.hasError && kReleaseMode)
                ? const ResetPasswordEmailForm()
                : ResetPasswordNewForm(code: code),
          ),
        );
      },
    );
  }
}
