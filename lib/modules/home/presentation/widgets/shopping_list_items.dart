import 'package:flutter/cupertino.dart';
import 'package:mcquenji_core/mcquenji_core.dart';
import 'package:shopping_list/modules/home/home.dart';

class ShoppingListItems extends StatelessWidget {
  const ShoppingListItems({super.key, required this.items, this.search});

  final List<ShoppingListItem> items;
  final String? search;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.square_list,
            size: 64,
            color: CupertinoColors.secondaryLabel.resolveFrom(context),
          ),
          16.vSpacing,
          'This list is empty. Add some items to get started'.text,
        ],
      );
    }

    final results = search != null
        ? items
            .where(
              (item) => item.name.toLowerCase().contains(search!.toLowerCase()),
            )
            .toList()
        : items;

    return Padding(
      padding: PaddingHorizontal(),
      child: ListView.separated(
        itemBuilder: (context, index) => ShoppingListItemTile(
          item: results[index],
        ),
        separatorBuilder: (context, index) => 10.vSpacing,
        itemCount: results.length,
      ),
    );
  }
}
