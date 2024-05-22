import 'package:cupertino_modal_sheet/cupertino_modal_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mcquenji_core/mcquenji_core.dart';
import 'package:shopping_list/modules/home/home.dart';
import 'package:shopping_list/utils.dart';

class ShoppingListItemTile extends StatefulWidget {
  const ShoppingListItemTile({super.key, required this.item});

  final ShoppingListItem item;

  @override
  State<ShoppingListItemTile> createState() => _ShoppingListItemTileState();
}

class _ShoppingListItemTileState extends State<ShoppingListItemTile> {
  bool checking = false;

  Future<void> toggleChecked() async {
    if (checking) return;

    setState(() {
      checking = true;
    });

    final items = context.read<ShoppingListItemsRepository>();

    await items.checkItem(widget.item.id);

    if (!mounted) return;

    setState(() {
      checking = false;
    });
  }

  Future<void> delete() async {
    final items = context.read<ShoppingListItemsRepository>();

    await items.deleteItem(widget.item.id);
  }

  void editItem() {
    showCupertinoModalSheet(
      context: context,
      firstTransition: CupertinoModalSheetRouteTransition.scale,
      fullscreenDialog: true,
      builder: (_) => CupertinoPageScaffold(
        backgroundColor:
            CupertinoColors.systemGroupedBackground.resolveFrom(context),
        navigationBar: CupertinoNavigationBar(
          middle: "Edit ${widget.item.name}".text,
        ),
        child: SafeArea(
          child: AddShoppingListItemForm(
            item: widget.item,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoContextMenu.builder(
      enableHapticFeedback: true,
      actions: [
        CupertinoContextMenuAction(
          trailingIcon: CupertinoIcons.pencil,
          onPressed: () async {
            Modular.to.pop();
            editItem();
          },
          child: "Edit".text,
        ),
        CupertinoContextMenuAction(
          isDestructiveAction: true,
          trailingIcon: CupertinoIcons.trash,
          onPressed: () async {
            await delete();
            Modular.to.pop();
          },
          child: context.t.shoppingLists_options_delete.text,
        ),
      ],
      builder: (context, animation) => GestureDetector(
        onTap: toggleChecked,
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
            key: ValueKey(widget.item),
            title: Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: widget.item.name.text.left,
              ),
            ),
            leading: checking
                ? const CupertinoActivityIndicator()
                : Icon(
                    widget.item.checked
                        ? CupertinoIcons.check_mark_circled_solid
                        : CupertinoIcons.circle,
                    color: widget.item.checked
                        ? CupertinoColors.systemGreen.resolveFrom(context)
                        : CupertinoColors.activeOrange.resolveFrom(context),
                  ),
            additionalInfo: widget.item.quantity.toString().text,
            subtitle: widget.item.checked ? "Bought".text : "Added".text,
          ),
        ),
      ),
    );
  }
}