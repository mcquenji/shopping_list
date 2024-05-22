import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mcquenji_core/mcquenji_core.dart';
import 'package:shopping_list/modules/auth/auth.dart';
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

  void logout() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        final user = context.watch<UserRepository>();

        return CupertinoActionSheet(
          title: t.shoppingLists_profile_title.text,
          message: user.state.when(
            data: (data) {
              return t.shoppingLists_profile_message(data?.name ?? "").text;
            },
            loading: () => const CupertinoActivityIndicator(),
            error: (_, __) => const CupertinoActivityIndicator(),
          ),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {},
              child: t.shoppingLists_profile_invite.text,
            ),
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () async {
                await user.signOut();
                Modular.to.navigate("/auth/");
              },
              child: t.shoppingLists_profile_logout.text,
            ),
          ],
        );
      },
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
          leading: isCollapsed
              ? null
              : CupertinoButton(
                  onPressed: addShoppingList,
                  child: t.shoppingLists_new_btn.text,
                ),
          actions: !isCollapsed
              ? null
              : CupertinoButton(
                  onPressed: addShoppingList,
                  child: t.shoppingLists_new_btn.text,
                ),
          largeTitle: SuperLargeTitle(
            textStyle: context.theme.textTheme.navLargeTitleTextStyle,
            largeTitle: t.shoppingLists_title,
            actions: [
              CupertinoButton(
                child: Icon(
                  CupertinoIcons.profile_circled,
                  size: theme.textTheme.navLargeTitleTextStyle.fontSize,
                ),
                onPressed: logout,
              )
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
        body: const SingleChildScrollView(child: ShoppingLists()),
      ),
    );
  }
}
