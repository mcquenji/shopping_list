import 'package:cupertino_modal_sheet/cupertino_modal_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mcquenji_core/mcquenji_core.dart';
import 'package:shopping_list/modules/app/app.dart';
import 'package:shopping_list/modules/home/home.dart';
import 'package:shopping_list/utils.dart';
import 'package:super_cupertino_navigation_bar/super_cupertino_navigation_bar.dart';

class ShoppingListItemsScreen extends StatefulWidget {
  const ShoppingListItemsScreen({super.key, required this.id});

  final String id;

  @override
  State<ShoppingListItemsScreen> createState() =>
      _ShoppingListItemsScreenState();
}

class _ShoppingListItemsScreenState extends State<ShoppingListItemsScreen> {
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    searchController.addListener(() {
      setState(() {});
    });
  }

  bool isCollapsed = false;

  void addItem() {
    showCupertinoModalSheet(
      context: context,
      firstTransition: CupertinoModalSheetRouteTransition.scale,
      fullscreenDialog: true,
      builder: (_) => CupertinoPageScaffold(
        backgroundColor:
            CupertinoColors.systemGroupedBackground.resolveFrom(context),
        navigationBar: CupertinoNavigationBar(
          middle: t.shoppingListItems_add.text,
        ),
        child: const SafeArea(child: AddShoppingListItemForm()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lists = context.watch<ShoppingListsRepository>();
    final items = context.watch<ShoppingListItemsRepository>();

    items.loadItems(widget.id);

    return CupertinoPageScaffold(
      backgroundColor:
          CupertinoColors.systemGroupedBackground.resolveFrom(context),
      child: lists.state.join(items.state).when(
            data: (data) {
              final lists = data.$1;
              final items = data.$2;

              final list = lists[widget.id];

              if (list == null) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      CupertinoIcons.exclamationmark_triangle,
                      size: 50,
                    ),
                    10.vSpacing,
                    t.shoppingListItems_notFound.text
                        .styled(theme.textTheme.navTitleTextStyle)
                        .centered,
                    t.shoppingListItems_notFound_message.text.centered,
                    CupertinoButton(
                      child: t.global_goBack.text,
                      onPressed: () => Modular.to.navigate("/"),
                    ),
                  ],
                );
              }

              return SuperScaffold(
                onCollapsed: (collapsed) {
                  setState(() {
                    isCollapsed = collapsed;
                  });
                },
                appBar: SuperAppBar(
                  title: list.name.text,
                  backgroundColor: CupertinoDynamicColor.resolve(
                    isCollapsed || searchController.text.isNotEmpty
                        ? CupertinoColors.secondarySystemGroupedBackground
                        : CupertinoColors.systemGroupedBackground,
                    context,
                  ),
                  largeTitle: SuperLargeTitle(
                    textStyle: theme.textTheme.navLargeTitleTextStyle,
                    largeTitle: list.name,
                  ),
                  leading: Modular.to.canPop()
                      ? null
                      : CupertinoButton(
                          child: Row(
                            children: [
                              const Icon(CupertinoIcons.back),
                              t.global_back.text,
                            ],
                          ),
                          onPressed: () => Modular.to.navigate("/"),
                        ),
                  actions: CupertinoButton(
                    onPressed: addItem,
                    child: t.shoppingListItems_add.text,
                  ),
                  searchBar: SuperSearchBar(
                    searchController: searchController,
                    resultColor: CupertinoColors.systemGroupedBackground
                        .resolveFrom(context),
                    searchResult: ShoppingListItems(
                      items: items.values.toList(),
                      search: searchController.text,
                    ),
                  ),
                ),
                body: ShoppingListItems(
                  items: items.values.toList(),
                  search: searchController.text,
                ),
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
