import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mcquenji_core/mcquenji_core.dart';
import 'package:shopping_list/modules/app/app.dart';
import 'package:shopping_list/modules/home/home.dart';
import 'package:shopping_list/utils.dart';

class ShoppingLists extends StatelessWidget {
  const ShoppingLists({super.key, this.searchQuery});

  final String? searchQuery;

  @override
  Widget build(BuildContext context) {
    final lists = context.watch<ShoppingListsRepository>();

    return Padding(
      padding: PaddingHorizontal(),
      child: lists.state.when(
        data: (data) {
          if (data.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  CupertinoIcons.square_list_fill,
                  size: 100,
                ),
                10.vSpacing,
                context.t.shoppingLists_empty_title.text.centered.styled(
                  context.theme.textTheme.navLargeTitleTextStyle,
                ),
                context.t.shoppingLists_empty_message.text.centered,
              ],
            );
          }

          if (searchQuery != null && searchQuery!.isNotEmpty) {
            final results = data.values
                .where(
                  (e) =>
                      e.name.toLowerCase().contains(searchQuery!.toLowerCase()),
                )
                .toList();

            if (results.isEmpty) return Container();

            return CupertinoListSection(
              children: [
                for (final list in results)
                  CupertinoListTile(
                    key: ValueKey(list.id),
                    title: list.name.text,
                    trailing: const CupertinoListTileChevron(),
                    onTap: () {},
                    additionalInfo: context.t
                        .shoppingLists_items(
                          list.items.where((e) => !e.checked).length,
                        )
                        .text,
                  ),
              ],
            );
          }

          return Column(
            children: [
              for (final list in data.values)
                ShoppingListTile(
                  key: ValueKey(list.id),
                  list: list,
                ),
            ],
          );
        },
        loading: () => Center(
          child: const CupertinoActivityIndicator().large(context),
        ),
        error: UnexpectedErrorWidget.handler,
      ),
    );
  }
}
