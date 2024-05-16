import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mcquenji_core/mcquenji_core.dart';
import 'package:shopping_list/modules/auth/auth.dart';
import 'package:shopping_list/modules/app/app.dart';
import 'package:shopping_list/utils.dart';

class CompleteProfileForm extends StatefulWidget {
  const CompleteProfileForm({super.key});

  @override
  State<CompleteProfileForm> createState() => _CompleteProfileFormState();
}

class _CompleteProfileFormState extends State<CompleteProfileForm> {
  final usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    usernameController.addListener(() {
      setState(() {});
    });
  }

  bool writing = false;
  bool get canSubmit => usernameController.text.isNotEmpty && !writing;

  Future<void> setUsername() async {
    setState(() {
      writing = true;
    });

    final username = usernameController.text;

    await context.read<UserRepository>().setUsermame(username.trim());

    setState(() {
      writing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const PaddingHorizontal(20).Bottom(10),
                child: Text(
                  context.t.completeProfile_title,
                  style: context.theme.textTheme.navLargeTitleTextStyle,
                ),
              ),
            ),
            CupertinoFormSection.insetGrouped(
              header: t.completeProfile_subtitle.text,
              children: [
                CupertinoFormRow(
                  prefix: const Icon(CupertinoIcons.person),
                  child: CupertinoTextFormFieldRow(
                    controller: usernameController,
                    placeholder: t.completeProfile_username,
                  ),
                ),
              ],
            ),
          ],
        ),
        CupertinoButton.filled(
          onPressed: canSubmit ? setUsername : null,
          child: writing
              ? const CupertinoActivityIndicator()
              : t.completeProfile_submit.text,
        ),
      ],
    );
  }
}
