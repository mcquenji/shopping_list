import 'dart:async';
export 'package:collection/collection.dart' show IterableExtension;

import 'package:mcquenji_core/mcquenji_core.dart';
import 'package:mcquenji_firebase/mcquenji_firebase.dart';
import 'package:shopping_list/modules/home/home.dart';

class ShoppingListItemsRepository
    extends Repository<AsyncValue<Map<String, ShoppingListItem>>> {
  static const String itemsSubcollection = "items";
  static const Duration maxCheckedAge = Duration(hours: 12);

  final TypedFirebaseFirestoreDataSource<ShoppingListItem> db;
  final FirebaseAuthService auth;

  ShoppingListItemsRepository(this.db, this.auth) : super(AsyncValue.loading());

  (String, StreamSubscription<Map<String, ShoppingListItem>>)? _watchedItems;

  Future<int> getItemsCount(String listId) async {
    return db.count(subcollection: "$listId/$itemsSubcollection");
  }

  Future<int> getUncheckedItemsCount(String listId) async {
    return db.count(
      subcollection: "$listId/$itemsSubcollection",
      where: DocumentQuery("checked", isEqualTo: false),
    );
  }

  Future<void> addItem(String name, int quantity) async {
    log("Adding item: $name");

    if (!state.hasData) {
      log("No list loaded, aborting");
      return;
    }

    try {
      final mergeInto = state.requireData.values.firstWhereOrNull(
        (item) =>
            item.name.toLowerCase() == name.toLowerCase() && !item.checked,
      );

      if (mergeInto != null) {
        log("Unchecked item already exists, merging");

        await _writeItem(
          mergeInto.copyWith(
            quantity: mergeInto.quantity + quantity,
            updatedAtTimestamp: DateTime.now().millisecondsSinceEpoch,
          ),
        );

        return;
      }

      final id = db.newDocumentId();

      final item = ShoppingListItem(
        id: id,
        name: name,
        quantity: quantity,
        createdAtTimestamp: DateTime.now().millisecondsSinceEpoch,
      );

      await _writeItem(item);

      log("Item added: $name");
    } catch (e, stack) {
      log("Error adding item: $name", e, stack);

      emit(AsyncValue.error(e, stack));
    }
  }

  Future<void> updateItem(String itemId, String name, int quantity) async {
    log("Updating item: $itemId");

    if (!state.hasData) {
      log("No list loaded, aborting");
      return;
    }

    final item = state.data!.values.firstWhereOrNull((i) => i.id == itemId);

    if (item == null) {
      log("Item not found, aborting");
      return;
    }

    await _writeItem(
      item.copyWith(
        name: name,
        quantity: quantity,
        updatedAtTimestamp: DateTime.now().millisecondsSinceEpoch,
      ),
    );

    log("Item updated: $itemId");
  }

  Future<void> _writeItem(ShoppingListItem item) async {
    log("Updating item: ${item.id}");

    if (!state.hasData) {
      log("No list loaded, aborting");
      return;
    }

    await db.write(item, "${_watchedItems!.$1}/$itemsSubcollection/${item.id}");

    log("Item updated: ${item.id}");
  }

  Future<void> deleteItem(String itemId) async {
    log("Deleting item: $itemId");

    if (!state.hasData) {
      log("No list loaded, aborting");
      return;
    }

    await db.delete("${_watchedItems!.$1}/$itemsSubcollection/$itemId");

    log("Item deleted: $itemId");
  }

  Future<void> checkItem(String itemId) async {
    log("Checking item: $itemId");

    if (!state.hasData) {
      log("No list loaded, aborting");
      return;
    }

    final item = state.data!.values.firstWhereOrNull((i) => i.id == itemId);

    if (item == null) {
      log("Item not found, aborting");
      return;
    }

    await _writeItem(
      item.copyWith(
        checked: !item.checked,
        buyerId: item.checked ? null : auth.currentUser?.uid,
        checkedAtTimestamp:
            item.checked ? null : DateTime.now().millisecondsSinceEpoch,
      ),
    );

    log("Item (un)checked: $itemId");
  }

  Future<void> loadItems(String listId) async {
    if (_watchedItems?.$1 != listId) emit(AsyncValue.loading());

    try {
      log("Loading items for list: $listId");

      if (_watchedItems?.$1 == listId) {
        log("Already watching items for list: $listId");
        return;
      }

      if (_watchedItems != null) {
        log("Cancelling previous watch on list: ${_watchedItems!.$1}");

        await unloadItems();
      }

      _watchedItems = (
        listId,
        db.watchAll(subcollection: "$listId/$itemsSubcollection").listen(
          (event) {
            emit(AsyncValue.data(event));
          },
        )
      );

      log("Now watching items for list: $listId");
    } catch (e, stack) {
      log("Error loading items for list: $listId", e, stack);

      emit(AsyncValue.error(e, stack));
    }

    log("Cleaning up old checked items (older than $maxCheckedAge) for list: $listId");

    try {
      final items =
          await db.readAll(subcollection: "$listId/$itemsSubcollection");

      int deleted = 0;

      for (final item in items.values) {
        if (!item.checked) continue;
        if (item.checkedAt == null) continue;

        final tooOld =
            DateTime.now().difference(item.checkedAt!).abs() > maxCheckedAge;

        if (!tooOld) continue;

        log("Deleting ${item.name}#${item.id} (checked at ${item.checkedAt})");
        await db.delete("$listId/$itemsSubcollection/${item.id}");

        deleted++;
      }

      log("Purged $deleted items");
    } catch (e, stack) {
      log("Error cleaning up old checked items for list: $listId", e, stack);
    }
  }

  Future<void> unloadItems() async {
    if (_watchedItems != null) {
      log("Cancelling watch on list: ${_watchedItems!.$1}");

      emit(AsyncValue.loading());

      await _watchedItems!.$2.cancel();

      _watchedItems = null;

      emit(AsyncValue.loading());
    }
  }

  @override
  void dispose() {
    _watchedItems?.$2.cancel();
  }
}
