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
              ? data.values
              : data.values
                  .where(
                    (e) => e.name
                        .toLowerCase()
                        .contains(searchQuery!.toLowerCase()),
                  )
                  .toList();

          return Column(
            children: [
              20.vSpacing,
              for (final list in results) ...[
                ShoppingListTile(
                  key: ValueKey(list.id),
                  list: list,
                ),
                10.vSpacing,
              ],
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
