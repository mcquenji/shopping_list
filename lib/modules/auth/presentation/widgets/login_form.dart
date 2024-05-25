import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mcquenji_core/mcquenji_core.dart';
import 'package:shopping_list/modules/auth/auth.dart';
import 'package:shopping_list/utils.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool invalidLogin = false;
  bool loggingIn = false;

  Future<void> login() async {
    setState(() {
      loggingIn = true;
      invalidLogin = false;
    });

    final email = emailController.text;
    final password = passwordController.text;

    final result = await context.read<UserRepository>().signIn(
          email.trim(),
          password.trim(),
        );

    if (!result) {
      setState(() {
        invalidLogin = true;
      });
    }

    setState(() {
      loggingIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Column(
            children: [
              CupertinoFormSection.insetGrouped(
                header: context.t.login_subtitle.text,
                children: [
                  CupertinoFormRow(
                    prefix: const Icon(CupertinoIcons.mail),
                    error: invalidLogin ? context.t.login_invalid.text : null,
                    child: CupertinoTextFormFieldRow(
                      controller: emailController,
                      placeholder: context.t.login_email,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [
                        AutofillHints.username,
                        AutofillHints.email,
                      ],
                    ),
                  ),
                  CupertinoFormRow(
                    prefix: const Icon(CupertinoIcons.lock),
                    error: invalidLogin ? context.t.login_invalid.text : null,
                    child: CupertinoTextFormFieldRow(
                      controller: passwordController,
                      placeholder: context.t.login_password,
                      autofillHints: const [
                        AutofillHints.password,
                      ],
                      obscureText: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: [
              CupertinoButton(
                onPressed: () {},
                child: t.login_forgot_password.text,
              ),
              CupertinoButton.filled(
                onPressed: loggingIn ? null : login,
                child: loggingIn
                    ? const CupertinoActivityIndicator()
                    : t.login_submit.text,
              ).stretch(PaddingHorizontal().Bottom(40)),
            ],
          ),
        ],
      ),
    );
  }
}
