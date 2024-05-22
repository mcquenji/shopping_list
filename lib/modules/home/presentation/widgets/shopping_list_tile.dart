import 'package:flutter/cupertino.dart';
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
  void deleteList() async {
    await context.read<ShoppingListsRepository>().deleteList(widget.list.id);
    Modular.to.pop();
  }

  void leaveList() async {
    await context.read<ShoppingListsRepository>().leaveList(widget.list.id);
    Modular.to.pop();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<FirebaseAuthService>();

    return CupertinoContextMenu.builder(
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
      builder: (context, animation) => GestureDetector(
        onTap: () {
          Modular.to.pushNamed("/${widget.list.id}");
        },
        child: Container(
          padding: PaddingVertical(10),
          width:
              context.screen.width - DeclarativeEdgeInsets.defaultPadding * 2,
          height: 64,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(15),
            ),
            color: CupertinoColors.secondarySystemGroupedBackground
                .resolveFrom(context),
          ),
          child: CupertinoListTile(
            key: ValueKey(widget.list.id),
            title: Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: widget.list.name.text.left,
              ),
            ),
            trailing: const CupertinoListTileChevron(),
            leading: Icon(
              widget.list.members.isNotEmpty
                  ? CupertinoIcons.person_2_fill
                  : CupertinoIcons.person_fill,
            ),
            additionalInfo: ShoppingListItemCount(widget.list.id),
          ),
        ),
      ),
    );
  }
}
