import 'package:flutter/cupertino.dart';
import 'package:mcquenji_core/mcquenji_core.dart';
import 'package:shopping_list/modules/home/home.dart';

class ShoppingListTile extends StatelessWidget {
  const ShoppingListTile({super.key, required this.list});

  final ShoppingList list;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: list.name.text,
    );
  }
}
