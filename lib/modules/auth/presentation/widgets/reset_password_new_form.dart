import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mcquenji_core/mcquenji_core.dart';
import 'package:mcquenji_firebase/mcquenji_firebase.dart';
import 'package:shopping_list/utils.dart';

class ResetPasswordNewForm extends StatefulWidget {
  const ResetPasswordNewForm({super.key, required this.code});

  final String code;

  @override
  State<ResetPasswordNewForm> createState() => _ResetPasswordNewFormState();

  static String? newPasswordValidator(
      BuildContext context, String? value, String other) {
    if (value == null || value.trim().isEmpty || other.trim().isEmpty) {
      return context.t.validation_password_tooShort;
    }

    if (value != other) {
      return context.t.validation_password_noMatch;
    }

    return null;
  }
}

class _ResetPasswordNewFormState extends State<ResetPasswordNewForm> {
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();

  bool submitting = false;
  bool showPassword = false;

  Future<void> submit() async {
    if (submitting) return;

    if (ResetPasswordNewForm.newPasswordValidator(
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

    await auth.confirmPasswordReset(
      code: widget.code,
      newPassword: passwordController.text.trim(),
    );
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
                validator: (value) => ResetPasswordNewForm.newPasswordValidator(
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
                validator: (value) => ResetPasswordNewForm.newPasswordValidator(
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
