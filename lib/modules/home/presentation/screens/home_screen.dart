import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mcquenji_core/mcquenji_core.dart';
import 'package:shopping_list/modules/home/home.dart';
import 'package:shopping_list/utils.dart';
import 'package:super_cupertino_navigation_bar/super_cupertino_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final searchController = TextEditingController();

  @override
  void initState() {
    searchController.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  bool isCollapsed = false;

  void addShoppingList() {
    Modular.to.push(
      CupertinoPageRoute(
        builder: (_) => const CreateShoppingListForm(),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoDynamicColor.resolve(
        CupertinoColors.systemGroupedBackground,
        context,
      ),
      child: SuperScaffold(
        onCollapsed: (collapsed) {
          setState(() {
            isCollapsed = collapsed;
          });
        },
        appBar: SuperAppBar(
          backgroundColor: CupertinoDynamicColor.resolve(
            isCollapsed || searchController.text.isNotEmpty
                ? CupertinoColors.systemBackground
                : CupertinoColors.systemGroupedBackground,
            context,
          ),
          actions: isCollapsed
              ? CupertinoButton(
                  onPressed: addShoppingList,
                  child: const Icon(CupertinoIcons.plus),
                )
              : null,
          largeTitle: SuperLargeTitle(
            textStyle: context.theme.textTheme.navLargeTitleTextStyle,
            largeTitle: t.shoppingLists_title,
            actions: [
              CupertinoButton(
                onPressed: addShoppingList,
                child: t.shoppingLists_new_btn.text,
              ),
            ],
          ),
          searchBar: SuperSearchBar(
            resultColor: CupertinoDynamicColor.resolve(
              CupertinoColors.systemGroupedBackground,
              context,
            ),
            textStyle: context.theme.textTheme.textStyle,
            searchController: searchController,
            searchResult: ShoppingLists(
              searchQuery: searchController.text,
            ),
          ),
        ),
        body: const ShoppingLists(),
      ),
    );
  }
}
