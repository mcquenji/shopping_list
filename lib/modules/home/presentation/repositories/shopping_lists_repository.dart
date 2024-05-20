import 'package:mcquenji_core/mcquenji_core.dart';
import 'package:mcquenji_firebase/mcquenji_firebase.dart';
import 'package:shopping_list/modules/home/domain/domain.dart';
import 'package:shopping_list/modules/home/home.dart';

class ShoppingListsRepository
    extends Repository<AsyncValue<Map<String, ShoppingList>>> {
  final TypedFirebaseFirestoreDataSource<ShoppingList> db;
  final FirebaseAuthService auth;

  ShoppingListsRepository(this.db, this.auth) : super(AsyncValue.loading()) {
    db.watchAll().listen((event) {
      // remove lists that the user is not a member of or not the owner of

      event.removeWhere((key, value) {
        final list = value;

        return list.owner != auth.currentUser!.uid &&
            !list.members.contains(auth.currentUser!.uid);
      });

      emit(AsyncValue.data(event));
    });
  }

  Future<void> createNewList(String name) async {
    log("Creating new list with name: $name");

    if (!auth.isAuthenticated) {
      log("User is not authenticated, aborting");
      return;
    }

    final id = db.newDocumentId();

    final list = ShoppingList(
      id: id,
      name: name,
      owner: auth.currentUser!.uid,
    );

    try {
      await db.write(list, id);

      log("List '$name' created successfully");
    } catch (e, s) {
      log("Error creating list: $name", e, s);
    }
  }

  Future<void> deleteList(String id) async {
    log("Deleting list with id: $id");

    if (!auth.isAuthenticated) {
      log("User is not authenticated, aborting");
      return;
    }

    try {
      await db.delete(id);

      log("List '$id' deleted successfully");
    } catch (e, s) {
      log("Error deleting list: $id", e, s);
    }
  }

  Future<void> addMember({required String id, required String memberId}) async {
    log("Adding member to list with id: $id");

    if (!auth.isAuthenticated) {
      log("User is not authenticated, aborting");
      return;
    }

    try {
      final list = await db.read(id);

      if (list.owner != auth.currentUser!.uid) {
        log("User is not the owner of the list, aborting");
        return;
      }

      if (list.members.contains(memberId)) {
        log("Member '$memberId' is already in the list, aborting");
        return;
      }

      final updatedList = list.copyWith(members: [...list.members, memberId]);

      await db.write(updatedList, id);

      log("Member '$memberId' added to list '$id' successfully");
    } catch (e, s) {
      log("Error adding member to list: $id", e, s);
    }
  }

  Future<void> removeMember(
      {required String id, required String memberId}) async {
    log("Removing member from list with id: $id");

    if (!auth.isAuthenticated) {
      log("User is not authenticated, aborting");
      return;
    }

    try {
      final list = await db.read(id);

      if (list.owner != auth.currentUser!.uid) {
        log("User is not the owner of the list, aborting");
        return;
      }

      if (!list.members.contains(memberId)) {
        log("Member '$memberId' is not in the list, aborting");
        return;
      }

      final updatedList = list.copyWith(
        members: list.members.where((m) => m != memberId).toList(),
      );

      await db.write(updatedList, id);

      log("Member '$memberId' removed from list '$id' successfully");
    } catch (e, s) {
      log("Error removing member from list: $id", e, s);
    }
  }

  Future<void> checkItem({
    required String listId,
    required ShoppingListItem item,
    bool checked = true,
  }) async {
    log("${checked ? "Checking" : "Unchecking"}  item '$item' in list with id: $listId");

    if (!auth.isAuthenticated) {
      log("User is not authenticated, aborting");
      return;
    }

    try {
      final list = await db.read(listId);

      if (!list.items.contains(item)) {
        log("Item '$item' is not in the list, aborting");
        return;
      }

      final updatedList = list.copyWith(
        items: list.items.map((i) {
          if (i == item) {
            return i.copyWith(checked: checked);
          }

          return i;
        }).toList(),
      );

      if (updatedList == list) {
        log("Item '$item' is already ${checked ? "" : "un"}checked, aborting");
        return;
      }

      await db.write(updatedList, listId);

      log("Item '$item' ${checked ? "" : "un"}checked successfully");
    } catch (e, s) {
      log("Error checking item: $item", e, s);
    }
  }

  Future<void> addItem(
      {required String listId, required ShoppingListItem item}) async {
    log("Adding item '$item' to list with id: $listId");

    if (!auth.isAuthenticated) {
      log("User is not authenticated, aborting");
      return;
    }

    try {
      final list = await db.read(listId);

      List<ShoppingListItem> items = list.items;

      if (list.items.contains(item)) {
        log("Item '$item' is already in the list, merging quantities");

        final oldItem = list.items.firstWhere((i) => i == item);
        final newItem =
            item.copyWith(quantity: oldItem.quantity + item.quantity);

        items = list.items.map((i) => i == oldItem ? newItem : i).toList();

        return;
      }

      final updatedList = list.copyWith(items: [...items, item]);
      await db.write(updatedList, listId);

      log("Item '$item' added to list '$listId' successfully");
    } catch (e, s) {
      log("Error adding item to list: $listId", e, s);
    }
  }

  Future<void> removeItem(
      {required String listId, required ShoppingListItem item}) async {
    log("Removing item '$item' from list with id: $listId");

    if (!auth.isAuthenticated) {
      log("User is not authenticated, aborting");
      return;
    }

    try {
      final list = await db.read(listId);

      if (!list.items.contains(item)) {
        log("Item '$item' is not in the list, aborting");
        return;
      }

      final updatedList = list.copyWith(
        items: list.items.where((i) => i != item).toList(),
      );

      await db.write(updatedList, listId);

      log("Item '$item' removed from list '$listId' successfully");
    } catch (e, s) {
      log("Error removing item from list: $listId", e, s);
    }
  }

  Future<void> leaveList(String id) async {
    log("Leaving list with id: $id");

    if (!auth.isAuthenticated) {
      log("User is not authenticated, aborting");
      return;
    }

    try {
      final list = await db.read(id);

      if (list.owner == auth.currentUser!.uid) {
        log("User is the owner of the list, aborting");
        return;
      }

      final updatedList = list.copyWith(
        members: list.members.where((m) => m != auth.currentUser!.uid).toList(),
      );

      await db.write(updatedList, id);

      log("User left list '$id' successfully");
    } catch (e, s) {
      log("Error leaving list: $id", e, s);
    }
  }

  @override
  void dispose() {}
}
