import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mcquenji_core/mcquenji_core.dart';
import 'package:shopping_list/modules/app/app.dart';
import 'package:shopping_list/modules/home/home.dart';
import 'package:shopping_list/utils.dart';
import 'package:super_cupertino_navigation_bar/super_cupertino_navigation_bar.dart';

class ShoppingListItemsScreen extends StatelessWidget {
  const ShoppingListItemsScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    final list = context.watch<ShoppingListsRepository>();

    return CupertinoPageScaffold(
      child: list.state.when(
        data: (data) => SuperScaffold(
          appBar: SuperAppBar(
            largeTitle: SuperLargeTitle(
              textStyle: context.theme.textTheme.navLargeTitleTextStyle,
              largeTitle: data[id]!.name,
            ),
            previousPageTitle: context.t.shoppingLists_title,
            actions: CupertinoButton(
              child: const Icon(CupertinoIcons.plus),
              onPressed: () {},
            ),
          ),
        ),
        loading: () => Center(
          child: const CupertinoActivityIndicator().large(context),
        ),
        error: UnexpectedErrorWidget.handler,
      ),
    );
  }
}
