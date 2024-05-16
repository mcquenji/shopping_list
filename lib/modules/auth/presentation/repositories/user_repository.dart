import 'package:mcquenji_core/mcquenji_core.dart';
import 'package:mcquenji_firebase/mcquenji_firebase.dart';
import 'package:shopping_list/modules/users/users.dart';

class UserRepository extends Repository<AsyncValue<User?>> {
  final TypedFirebaseFirestoreDataSource<User> _users;
  final FirebaseAuthService _auth;

  UserRepository(this._users, this._auth) : super(AsyncValue.loading()) {
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    log('Loading current user...');

    if (!_auth.isAuthenticated) {
      log('User is not authenticated.');

      return emit(AsyncValue.data(null));
    }

    try {
      final user = await _users.read(_auth.currentUser!.uid);

      log('User loaded: $user');

      emit(AsyncValue.data(user));
    } on DocumentNotFoundException catch (_) {
      log('User not found in database. Creating...');

      final user = User(
        id: _auth.currentUser!.uid,
        email: _auth.currentUser!.email!,
        name: '',
      );

      await _users.write(user, user.id);

      log('User created: $user');

      emit(AsyncValue.data(user));
    }
  }

  Future<bool> signIn(String email, String password) async {
    log('Signing in...');

    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      log('Successfully signed in.');

      await _loadCurrentUser();

      return true;
    } catch (e, stack) {
      log('Failed to sign in', e, stack);

      return false;
    }
  }

  Future<void> signOut() async {
    log('Signing out...');

    if (!_auth.isAuthenticated) {
      log('No user signed in. Aborting...');

      return;
    }

    await _auth.signOut();

    emit(AsyncValue.data(null));

    log('Signed out.');
  }

  Future<void> setUsermame(String name) async {
    if (name.isEmpty) return emit(AsyncValue.error('Name cannot be empty.'));

    if (!state.hasData) return;
    if (state.data == null) return;

    final guard = await AsyncValue.guard(() async {
      final user = state.data!.copyWith(name: name);

      await _users.write(user, user.id);

      return user;
    });

    emit(guard);
  }

  Future<void> signUp(String email, String password) async {
    // TODO: check referrer code

    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    _loadCurrentUser();
  }

  Future<void> requestPasswordReset(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> resetPassword(String code, String newPassword) async {
    await _auth.confirmPasswordReset(code: code, newPassword: newPassword);
  }

  @override
  void dispose() {}
}
