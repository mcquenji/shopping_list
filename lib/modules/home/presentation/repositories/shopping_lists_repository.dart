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
