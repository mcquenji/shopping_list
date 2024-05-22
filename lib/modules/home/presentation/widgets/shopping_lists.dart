import 'package:flutter/cupertino.dart';
import 'package:mcquenji_core/mcquenji_core.dart';
import 'package:shopping_list/modules/home/home.dart';
import 'package:shopping_list/utils.dart';

class ShoppingLists extends StatelessWidget {
  const ShoppingLists(this.lists, {super.key, this.searchQuery});

  final Map<String, ShoppingList> lists;
  final String? searchQuery;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PaddingHorizontal(),
      child: Builder(
        builder: (context) {
          if (lists.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    CupertinoIcons.nosign,
                    color: CupertinoColors.systemGrey,
                    size: 50,
                  ),
                  10.vSpacing,
                  context.t.shoppingLists_empty_title.text.centered.styled(
                    context.theme.textTheme.navTitleTextStyle,
                  ),
                  context.t.shoppingLists_empty_message.text.centered,
                ],
              ),
            );
          }

          final results = searchQuery == null
              ? lists.values.toList()
              : lists.values
                  .where(
                    (e) => e.name
                        .toLowerCase()
                        .contains(searchQuery!.toLowerCase()),
                  )
                  .toList();

          return ListView.separated(
            separatorBuilder: (context, index) => 10.vSpacing,
            itemBuilder: (context, index) {
              final list = results[index];

              return ShoppingListTile(
                key: ValueKey(list.id),
                list: list,
              );
            },
            itemCount: results.length,
          );
        },
      ),
    );
  }
}
