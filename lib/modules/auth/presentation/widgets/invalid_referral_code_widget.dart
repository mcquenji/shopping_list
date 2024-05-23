import 'package:flutter/cupertino.dart';
import 'package:mcquenji_core/mcquenji_core.dart';
import 'package:shopping_list/utils.dart';

class InvalidReferralCodeWidget extends StatelessWidget {
  const InvalidReferralCodeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PaddingHorizontal(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.lock_fill,
            size: 100,
            color: CupertinoColors.systemBlue.resolveFrom(context),
          ),
          20.vSpacing,
          context.t.register_invalidReferral.text.centered.styled(
            context.theme.textTheme.navLargeTitleTextStyle,
          ),
          5.vSpacing,
          context.t.register_invalidReferral_message.text.centered,
        ],
      ),
    );
  }
}
