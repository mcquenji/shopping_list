import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mcquenji_core/mcquenji_core.dart';
import 'package:mcquenji_firebase/mcquenji_firebase.dart';
import 'package:shopping_list/modules/app/app.dart';
import 'package:shopping_list/modules/auth/auth.dart';
import 'package:shopping_list/modules/home/home.dart';
import 'package:shopping_list/utils.dart';

class AddMemberForm extends StatefulWidget {
  const AddMemberForm({super.key, required this.list});

  final ShoppingList list;

  @override
  State<AddMemberForm> createState() => _AddMemberFormState();
}

class _AddMemberFormState extends State<AddMemberForm> {
  Future<void> removeMember(String id) async {
    await context
        .read<ShoppingListsRepository>()
        .removeMember(id: widget.list.id, memberId: id);
  }

  Future<void> addMember(String id) async {
    await context
        .read<ShoppingListsRepository>()
        .addMember(id: widget.list.id, memberId: id);
  }

  @override
  Widget build(BuildContext context) {
    final users = context.read<TypedFirebaseFirestoreDataSource<User>>();
    final auth = context.read<FirebaseAuthService>();
    final lists = context.watch<ShoppingListsRepository>();

    return lists.state.when(
      data: (lists) => StreamBuilder<Map<String, User>>(
        stream: users.watchAll(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CupertinoActivityIndicator());
          }

          final list = lists[widget.list.id];

          if (list == null) {
            return const Center(child: CupertinoActivityIndicator());
          }

          final members = list.members
              .map(
                (e) => snapshot.requireData[e]!,
              )
              .toList();

          final inviteableUsers = snapshot.requireData.values
              .where(
                (e) => !members.contains(e) && e.id != auth.currentUser?.uid,
              )
              .toList();

          return ListView(
            children: [
              if (members.isNotEmpty)
                CupertinoListSection.insetGrouped(
                  header: t.shoppingLists_options_share_manage.text,
                  children: [
                    for (final member in members)
                      CupertinoListTile(
                        title: member.name.text,
                        subtitle: member.email.text,
                        trailing: CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Icon(
                            CupertinoIcons.person_crop_circle_badge_minus,
                            color:
                                CupertinoColors.systemRed.resolveFrom(context),
                          ),
                          onPressed: () => removeMember(member.id),
                        ),
                      ),
                  ],
                ),
              CupertinoListSection.insetGrouped(
                header: t.shoppingLists_options_share_invite.text,
                children: [
                  for (final user in inviteableUsers)
                    CupertinoListTile(
                      title: user.name.text,
                      subtitle: user.email.text,
                      trailing: CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: const Icon(
                          CupertinoIcons.person_crop_circle_badge_plus,
                        ),
                        onPressed: () => addMember(user.id),
                      ),
                    )
                ],
              ),
            ],
          );
        },
      ),
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: UnexpectedErrorWidget.handler,
    );
  }
}
