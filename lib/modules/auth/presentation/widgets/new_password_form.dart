import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mcquenji_core/mcquenji_core.dart';
import 'package:mcquenji_firebase/mcquenji_firebase.dart';
import 'package:shopping_list/utils.dart';

class NewPasswordForm extends StatefulWidget {
  const NewPasswordForm({super.key, required this.code});

  final String code;

  @override
  State<NewPasswordForm> createState() => _NewPasswordFormState();

  static String? newPasswordValidator(
      BuildContext context, String? value, String other) {
    if (value != other) {
      return context.t.validation_password_noMatch;
    }

    if (value == null || value.trim().length < 6 || other.trim().length < 6) {
      return context.t.validation_password_tooShort;
    }

    return null;
  }
}

class _NewPasswordFormState extends State<NewPasswordForm> {
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();

  bool submitting = false;
  bool showPassword = false;

  Future<void> submit() async {
    if (submitting) return;

    if (NewPasswordForm.newPasswordValidator(
          context,
          passwordController.text,
          repeatPasswordController.text,
        ) !=
        null) {
      return;
    }

    setState(() {
      submitting = true;
    });

    final auth = context.read<FirebaseAuthService>();

    if (kReleaseMode) {
      await auth.confirmPasswordReset(
        code: widget.code,
        newPassword: passwordController.text.trim(),
      );
    }

    setState(() {
      submitting = false;
    });

    Modular.to.navigate('/auth/');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CupertinoFormSection.insetGrouped(
          header: t.resetPassword_new_title.text,
          children: [
            CupertinoFormRow(
              prefix: const Icon(CupertinoIcons.lock),
              child: CupertinoTextFormFieldRow(
                controller: passwordController,
                placeholder: context.t.resetPassword_new,
                obscureText: !showPassword,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => NewPasswordForm.newPasswordValidator(
                  context,
                  value,
                  repeatPasswordController.text,
                ),
              ),
            ),
            CupertinoFormRow(
              prefix: const Icon(CupertinoIcons.lock),
              child: CupertinoTextFormFieldRow(
                controller: repeatPasswordController,
                placeholder: context.t.resetPassword_repeat,
                obscureText: !showPassword,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => NewPasswordForm.newPasswordValidator(
                  context,
                  value,
                  passwordController.text,
                ),
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
        CupertinoButton.filled(
          onPressed: submitting ? null : submit,
          child: submitting
              ? const CupertinoActivityIndicator()
              : t.resetPassword_submit.text,
        ).stretch(PaddingHorizontal().Bottom(40)),
      ],
    );
  }
}
