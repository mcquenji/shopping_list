import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
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
            isCollapsed
                ? CupertinoColors.systemBackground
                : CupertinoColors.systemGroupedBackground,
            context,
          ),
          largeTitle: SuperLargeTitle(
            largeTitle: t.shoppingLists_title,
          ),
          actions: CupertinoButton(
            onPressed: addShoppingList,
            child: const Icon(CupertinoIcons.add),
          ),
          searchBar: SuperSearchBar(
            searchController: searchController,
            searchResult: Container(
              color: CupertinoDynamicColor.resolve(
                CupertinoColors.systemGroupedBackground,
                context,
              ),
              child: ShoppingLists(
                searchQuery: searchController.text,
              ),
            ),
          ),
        ),
        body: const ShoppingLists(),
      ),
    );
  }
}
