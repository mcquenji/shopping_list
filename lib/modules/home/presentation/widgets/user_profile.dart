import 'package:cupertino_modal_sheet/cupertino_modal_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mcquenji_core/mcquenji_core.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shopping_list/modules/auth/auth.dart';
import 'package:shopping_list/modules/home/home.dart';
import 'package:shopping_list/utils.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () => showCupertinoModalPopup(
        context: context,
        builder: (context) {
          final user = context.watch<UserRepository>();

          return Padding(
            padding: PaddingBottom(40),
            child: CupertinoActionSheet(
              title: context.t.shoppingLists_profile_title.text,
              message: Column(
                children: [
                  user.state.when(
                    data: (data) {
                      return context.t
                          .shoppingLists_profile_message(data?.name ?? "")
                          .text;
                    },
                    loading: () => const CupertinoActivityIndicator(),
                    error: (_, __) => const CupertinoActivityIndicator(),
                  ),
                  5.vSpacing,
                  FutureBuilder(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, packageInfo) {
                      if (!packageInfo.hasData) {
                        return context.t.version("").text.centered;
                      }

                      final String version =
                          "${packageInfo.requireData.version}+${packageInfo.requireData.buildNumber}";

                      return context.t.version(version).text.centered;
                    },
                  ),
                ],
              ),
              actions: [
                CupertinoActionSheetAction(
                  onPressed: () {
                    Modular.to.pop();
                    showCupertinoModalSheet(
                      context: context,
                      firstTransition: CupertinoModalSheetRouteTransition.scale,
                      fullscreenDialog: true,
                      builder: (context) => CupertinoPageScaffold(
                        backgroundColor: CupertinoColors.systemGroupedBackground
                            .resolveFrom(context),
                        navigationBar: CupertinoNavigationBar(
                          middle: context.t.invite_friend_title.text,
                        ),
                        child: const SafeArea(child: InviteFriendForm()),
                      ),
                    );
                  },
                  child: context.t.shoppingLists_profile_invite.text,
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                isDestructiveAction: true,
                onPressed: () async {
                  await user.signOut();
                  Modular.to.navigate("/auth/");
                },
                child: context.t.shoppingLists_profile_logout.text,
              ),
            ),
          );
        },
      ),
      child: Icon(
        CupertinoIcons.profile_circled,
        size: context.theme.textTheme.navLargeTitleTextStyle.fontSize,
      ),
    );
  }
}
