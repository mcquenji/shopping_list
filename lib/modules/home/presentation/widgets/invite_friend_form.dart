import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mcquenji_core/mcquenji_core.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shopping_list/modules/app/app.dart';
import 'package:shopping_list/modules/auth/auth.dart';
import 'package:shopping_list/utils.dart';

class InviteFriendForm extends StatelessWidget {
  const InviteFriendForm({super.key});

  @override
  Widget build(BuildContext context) {
    final referrals = context.watch<SignUpRepository>();

    return referrals.state.when(
      data: (_) => Online(
        builder: (context) => FutureBuilder<String?>(
          future: referrals.gnereateReferralCode(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: const CupertinoActivityIndicator().large(context),
              );
            }

            final code = snapshot.requireData;

            if (code == null) {
              return Center(
                child: const CupertinoActivityIndicator().large(context),
              );
            }

            final link = "${Uri.base}#/auth/register/$code";

            return Padding(
              padding: PaddingAll(),
              child: Column(
                children: [
                  context.t.invite_friend_message.text.centered,
                  15.vSpacing,
                  Container(
                    padding: PaddingAll(),
                    decoration: BoxDecoration(
                      color: CupertinoColors.secondarySystemGroupedBackground
                          .resolveFrom(context),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        QrImageView(
                          size: context.screen.width * 0.8,
                          data: link,
                          dataModuleStyle: QrDataModuleStyle(
                            dataModuleShape: QrDataModuleShape.circle,
                            color: CupertinoColors.label.resolveFrom(context),
                          ),
                          eyeStyle: QrEyeStyle(
                            eyeShape: QrEyeShape.circle,
                            color: CupertinoColors.label.resolveFrom(context),
                          ),
                        ),
                        context.t.register_invalidReferral_scan.text.styled(
                          context.theme.textTheme.navTitleTextStyle,
                        ),
                      ],
                    ),
                  ).center(),
                  CupertinoButton(
                    onPressed: () {
                      Share.share(
                        context.t.invite_friend_link_message(link),
                        subject: context.t.invite_friend_link_subject,
                      );
                    },
                    child: context.t.invite_friend_link.text,
                  ),
                ],
              ),
            );
          },
        ),
      ),
      loading: () => Center(
        child: const CupertinoActivityIndicator().large(context),
      ),
      error: UnexpectedErrorWidget.handler,
    );
  }
}
