import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mcquenji_core/mcquenji_core.dart';
import 'package:mcquenji_firebase/mcquenji_firebase.dart';
import 'package:shopping_list/modules/home/home.dart';
import 'package:shopping_list/utils.dart';

class ShoppingListTile extends StatefulWidget {
  const ShoppingListTile({super.key, required this.list});

  final ShoppingList list;

  @override
  State<ShoppingListTile> createState() => _ShoppingListTileState();
}

class _ShoppingListTileState extends State<ShoppingListTile> {
  void deleteList() {
    // showCupertinoDialog(
    //   context: context,
    //   builder: (_) => CupertinoAlertDialog(
    //     title: "Delete list".text,
    //     content: "Are you sure you want to delete '${widget.list.name}'?".text,
    //     actions: [
    //       CupertinoDialogAction(
    //         child: "Cancel".text,
    //         onPressed: () {
    //           Navigator.of(context).pop();
    //         },
    //       ),
    //       CupertinoDialogAction(
    //         child: "Delete".text,
    //         isDestructiveAction: true,
    //         onPressed: () {
    //           context
    //               .read<ShoppingListsRepository>()
    //               .deleteList(widget.list.id);
    //           Navigator.of(context).pop();
    //         },
    //       ),
    //     ],
    //   ),
    // );

    context.read<ShoppingListsRepository>().deleteList(widget.list.id);
    Modular.to.pop();
  }

  void leaveList() {
    // showCupertinoDialog(
    //   context: context,
    //   builder: (_) => CupertinoAlertDialog(
    //     title: "Leave list".text,
    //     content: "Are you sure you want to leave '${widget.list.name}'?".text,
    //     actions: [
    //       CupertinoDialogAction(
    //         child: "Cancel".text,
    //         onPressed: () {
    //           Navigator.of(context).pop();
    //         },
    //       ),
    //       CupertinoDialogAction(
    //         child: "Leave".text,
    //         isDestructiveAction: true,
    //         onPressed: () {
    //           context.read<ShoppingListsRepository>().leaveList(widget.list.id);
    //           Navigator.of(context).pop();
    //         },
    //       ),
    //     ],
    //   ),
    // );

    context.read<ShoppingListsRepository>().leaveList(widget.list.id);

    Modular.to.pop();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<FirebaseAuthService>();

    return CupertinoContextMenu(
      enableHapticFeedback: true,
      actions: [
        if (widget.list.owner == auth.currentUser?.uid)
          CupertinoContextMenuAction(
            trailingIcon: CupertinoIcons.person_crop_circle_badge_plus,
            onPressed: () {},
            child: t.shoppingLists_options_share.text,
          ),
        if (widget.list.owner == auth.currentUser?.uid)
          CupertinoContextMenuAction(
            isDestructiveAction: true,
            trailingIcon: CupertinoIcons.trash,
            onPressed: deleteList,
            child: t.shoppingLists_options_delete.text,
          ),
        if (widget.list.members.contains(auth.currentUser?.uid))
          CupertinoContextMenuAction(
            isDestructiveAction: true,
            trailingIcon: CupertinoIcons.person_crop_circle_badge_xmark,
            onPressed: leaveList,
            child: t.shoppingLists_options_leave.text,
          ),
      ],
      child: GestureDetector(
        onTap: () {
          Modular.to.pushNamed("/${widget.list.id}");
        },
        child: Container(
          padding: PaddingVertical(10),
          width:
              context.screen.width - DeclarativeEdgeInsets.defaultPadding * 2,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(15),
            ),
            color: CupertinoDynamicColor.resolve(
              CupertinoColors.systemFill,
              context,
            ),
          ),
          child: CupertinoListTile(
            key: ValueKey(widget.list.id),
            title: widget.list.name.text,
            trailing: const CupertinoListTileChevron(),
            leading: Icon(
              widget.list.members.isNotEmpty
                  ? CupertinoIcons.person_2_fill
                  : CupertinoIcons.person_fill,
            ),
            additionalInfo: context.t
                .shoppingLists_items(
                  widget.list.items.where((e) => !e.checked).length,
                )
                .text,
          ),
        ),
      ),
    );
  }
}
