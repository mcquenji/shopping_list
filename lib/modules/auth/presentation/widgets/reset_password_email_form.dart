import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mcquenji_core/mcquenji_core.dart';
import 'package:mcquenji_firebase/mcquenji_firebase.dart';
import 'package:shopping_list/utils.dart';

class ResetPasswordEmailForm extends StatefulWidget {
  const ResetPasswordEmailForm({super.key});

  @override
  State<ResetPasswordEmailForm> createState() => _ResetPasswordEmailFormState();
}

class _ResetPasswordEmailFormState extends State<ResetPasswordEmailForm> {
  final emailController = TextEditingController();

  bool sendingEmail = false;
  bool emailSent = false;

  Future<void> sendEmail() async {
    setState(() {
      sendingEmail = true;
      emailSent = false;
    });

    final auth = context.read<FirebaseAuthService>();

    if (kReleaseMode) {
      try {
        await auth.sendPasswordResetEmail(email: emailController.text.trim());
      } finally {}
    }

    setState(() {
      sendingEmail = false;
      emailSent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (emailSent) {
      return Padding(
        padding: PaddingHorizontal(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.checkmark_circle_fill,
                size: 150,
                color: CupertinoColors.systemGreen.resolveFrom(context),
              ),
              10.vSpacing,
              t.resetPassword_email_sent.text.styled(
                theme.textTheme.navLargeTitleTextStyle,
              ),
              5.vSpacing,
              t.resetPassword_email_sent_message.text.centered,
              5.vSpacing,
              t.resetPassword_email_sent_message_hint.text.centered.styled(
                TextStyle(
                  fontSize: 13.0,
                  color: CupertinoColors.secondaryLabel.resolveFrom(context),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return AutofillGroup(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CupertinoFormSection.insetGrouped(
            header: "".text,
            footer: t.resetPassword_email_message.text,
            children: [
              CupertinoFormRow(
                prefix: const Icon(CupertinoIcons.mail),
                child: CupertinoTextFormFieldRow(
                  placeholder: t.resetPassword_email,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [
                    AutofillHints.email,
                    AutofillHints.username,
                  ],
                ),
              ),
            ],
          ),
          CupertinoButton.filled(
            onPressed: sendingEmail ? null : sendEmail,
            child: sendingEmail
                ? const CupertinoActivityIndicator()
                : t.resetPassword_email_send.text,
          ).stretch(PaddingHorizontal().Bottom(40)),
        ],
      ),
    );
  }
}
