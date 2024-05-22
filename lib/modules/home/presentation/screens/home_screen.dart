import 'package:cupertino_modal_sheet/cupertino_modal_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mcquenji_core/mcquenji_core.dart';
import 'package:shopping_list/modules/app/app.dart';
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
    showCupertinoModalSheet(
      context: context,
      firstTransition: CupertinoModalSheetRouteTransition.scale,
      fullscreenDialog: true,
      builder: (_) => CupertinoPageScaffold(
        backgroundColor:
            CupertinoColors.systemGroupedBackground.resolveFrom(context),
        navigationBar: CupertinoNavigationBar(
          middle: t.shoppingLists_new_title.text,
        ),
        child: const CreateShoppingListForm(),
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
    final lists = context.watch<ShoppingListsRepository>();

    return CupertinoPageScaffold(
      backgroundColor:
          CupertinoColors.systemGroupedBackground.resolveFrom(context),
      child: lists.state.when(
        data: (lists) => SuperScaffold(
          onCollapsed: (collapsed) {
            setState(() {
              isCollapsed = collapsed;
            });
          },
          appBar: SuperAppBar(
            backgroundColor: CupertinoDynamicColor.resolve(
              isCollapsed || searchController.text.isNotEmpty
                  ? CupertinoColors.secondarySystemGroupedBackground
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
                  onPressed: logout,
                  child: Icon(
                    CupertinoIcons.profile_circled,
                    size: theme.textTheme.navLargeTitleTextStyle.fontSize,
                  ),
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
                lists,
                searchQuery: searchController.text,
              ),
            ),
          ),
          body: ShoppingLists(lists),
        ),
        loading: () => const CupertinoActivityIndicator().large(context),
        error: UnexpectedErrorWidget.handler,
      ),
    );
  }
}
