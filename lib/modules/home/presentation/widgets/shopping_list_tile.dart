import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mcquenji_core/mcquenji_core.dart';
import 'package:shopping_list/modules/home/home.dart';
import 'package:shopping_list/utils.dart';

class ShoppingListTile extends StatelessWidget {
  const ShoppingListTile({super.key, required this.list});

  final ShoppingList list;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Modular.to.pushNamed("/${list.id}");
      },
      child: Container(
        padding: PaddingAll(10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
          color: CupertinoDynamicColor.resolve(
            CupertinoColors.tertiarySystemFill,
            context,
          ),
        ),
        child: CupertinoListTile(
          key: ValueKey(list.id),
          title: list.name.text,
          trailing: const CupertinoListTileChevron(),
          additionalInfo: context.t
              .shoppingLists_items(
                list.items.where((e) => !e.checked).length,
              )
              .text,
        ),
      ),
    );
  }
}
