import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mcquenji_core/mcquenji_core.dart';
import 'package:shopping_list/modules/auth/auth.dart';
import 'package:shopping_list/utils.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key, this.referralCode});

  final String? referralCode;

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();

  @override
  void initState() {
    passwordController.addListener(() {
      setState(() {});
    });

    repeatPasswordController.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  bool get doPasswordsMatch =>
      passwordController.text == repeatPasswordController.text;

  bool get isFormValid =>
      usernameController.text.isNotEmpty &&
      emailController.text.isNotEmpty &&
      passwordController.text.isNotEmpty &&
      repeatPasswordController.text.isNotEmpty &&
      doPasswordsMatch;

  bool isSubmitting = false;
  bool error = false;
  bool showPassword = false;

  Future<void> register() async {
    if (!isFormValid) return;

    setState(() {
      isSubmitting = true;
    });

    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final username = usernameController.text.trim();

    final signUp = context.read<SignUpRepository>();

    if (widget.referralCode == null) {
      error = !await signUp.signUpFirstUser(
        email: email,
        password: password,
        username: username,
      );
    } else {
      error = !await signUp.signUp(
        code: widget.referralCode!,
        email: email,
        password: password,
        username: username,
      );
    }

    setState(() {
      isSubmitting = false;
    });

    if (!error) {
      TextInput.finishAutofillContext();
      Modular.to.navigate("/");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CupertinoFormSection.insetGrouped(
            header: t.register_subtitle.text,
            children: [
              CupertinoFormRow(
                prefix: const Icon(CupertinoIcons.person),
                child: CupertinoTextFormFieldRow(
                  controller: usernameController,
                  placeholder: context.t.register_name,
                  keyboardType: TextInputType.name,
                  autofillHints: const [
                    AutofillHints.name,
                    AutofillHints.nickname,
                  ],
                ),
              ),
              CupertinoFormRow(
                prefix: const Icon(CupertinoIcons.mail),
                error: error ? t.register_invalidEmail.text : null,
                child: CupertinoTextFormFieldRow(
                  controller: emailController,
                  placeholder: context.t.register_email,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [
                    AutofillHints.email,
                    AutofillHints.username,
                  ],
                ),
              ),
              CupertinoFormRow(
                prefix: const Icon(CupertinoIcons.lock),
                error: doPasswordsMatch
                    ? null
                    : context.t.register_invalidPassword.text,
                child: CupertinoTextFormFieldRow(
                  controller: passwordController,
                  placeholder: context.t.register_password,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: !showPassword,
                  autofillHints: const [
                    AutofillHints.newPassword,
                    AutofillHints.password,
                  ],
                ),
              ),
              CupertinoFormRow(
                prefix: const Icon(CupertinoIcons.lock),
                error: doPasswordsMatch
                    ? null
                    : context.t.register_invalidPassword.text,
                child: CupertinoTextFormFieldRow(
                  controller: repeatPasswordController,
                  placeholder: context.t.register_repeatPassword,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: !showPassword,
                  autofillHints: const [AutofillHints.password],
                ),
              ),
              CupertinoFormRow(
                prefix: t.showPassword.text,
                child: CupertinoSwitch(
                  value: showPassword,
                  onChanged: (value) => setState(() => showPassword = value),
                ),
              ),
            ],
          ),
          Column(
            children: [
              CupertinoButton(
                onPressed: () {
                  Modular.to.pushNamed("/auth/");
                },
                child: t.register_already.text,
              ),
              CupertinoButton.filled(
                onPressed: isSubmitting || !isFormValid ? null : register,
                child: isSubmitting
                    ? const CupertinoActivityIndicator()
                    : t.register_submit.text,
              ).stretch(PaddingHorizontal().Bottom(40)),
            ],
          )
        ],
      ),
    );
  }
}
