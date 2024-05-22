import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mcquenji_core/mcquenji_core.dart';
import 'package:shopping_list/modules/home/home.dart';
import 'package:shopping_list/utils.dart';

class ShoppingListItemCount extends StatelessWidget {
  const ShoppingListItemCount(
    this.listId, {
    super.key,
    this.showAll = false,
  });

  final String listId;
  final bool showAll;

  @override
  Widget build(BuildContext context) {
    final items = context.watch<ShoppingListItemsRepository>();

    return FutureBuilder(
      future: showAll
          ? items.getItemsCount(listId)
          : items.getCheckedItemsCount(listId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CupertinoActivityIndicator();
        }

        return context.t.shoppingLists_items(snapshot.requireData).text;
      },
    );
  }
}
