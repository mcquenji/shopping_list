import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mcquenji_core/mcquenji_core.dart';
import 'package:mcquenji_firebase/mcquenji_firebase.dart';
import 'package:shopping_list/modules/home/home.dart';
import 'package:shopping_list/utils.dart';

class ShoppingListTile extends StatelessWidget {
  const ShoppingListTile({super.key, required this.list});

  final ShoppingList list;

  @override
  Widget build(BuildContext context) {
    final auth = context.read<FirebaseAuthService>();

    return CupertinoContextMenu(
      enableHapticFeedback: true,
      actions: [
        if (list.owner == auth.currentUser?.uid)
          CupertinoContextMenuAction(
            child: "Share".text,
            trailingIcon: CupertinoIcons.arrowshape_turn_up_right,
            onPressed: () {},
          ),
        if (list.owner == auth.currentUser?.uid)
          CupertinoContextMenuAction(
            child: "Delete".text,
            isDestructiveAction: true,
            trailingIcon: CupertinoIcons.trash,
            onPressed: () {
              context.read<ShoppingListsRepository>().deleteList(list.id);
            },
          ),
        if (list.members.contains(auth.currentUser?.uid))
          CupertinoContextMenuAction(
            child: "Leave".text,
            isDestructiveAction: true,
            trailingIcon: CupertinoIcons.person_crop_circle_badge_xmark,
            onPressed: () {
              context.read<ShoppingListsRepository>().leaveList(list.id);
            },
          ),
      ],
      child: GestureDetector(
        onTap: () {
          Modular.to.pushNamed("/${list.id}");
        },
        child: Container(
          padding: PaddingAll(10),
          width:
              context.screen.width - DeclarativeEdgeInsets.defaultPadding * 2,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(15),
            ),
            color: CupertinoDynamicColor.resolve(
              CupertinoColors.tertiarySystemFill,
              context,
            ),
          ),
          // child: CupertinoListTile(
          //   key: ValueKey(list.id),
          //   title: list.name.text,
          //   trailing: const CupertinoListTileChevron(),
          //   additionalInfo: context.t
          //       .shoppingLists_items(
          //         list.items.where((e) => !e.checked).length,
          //       )
          //       .text,
          // ),
          child: FlutterLogo(size: 100),
        ),
      ),
    );
  }
}
