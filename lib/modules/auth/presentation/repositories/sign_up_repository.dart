import 'package:mcquenji_core/mcquenji_core.dart';
import 'package:mcquenji_firebase/mcquenji_firebase.dart';
import 'package:shopping_list/modules/auth/auth.dart';

class SignUpRepository extends Repository<AsyncValue<Map<String, Referral>>> {
  final TypedFirebaseFirestoreDataSource<Referral> db;
  final FirebaseAuthService auth;
  final UserRepository userRepository;

  SignUpRepository(this.db, this.auth, this.userRepository)
      : super(AsyncValue.loading()) {
    db.watchAll().listen((event) {
      emit(AsyncValue.data(event));
    });
  }

  bool validateReferralCode(String code) {
    log("Validating referral code: $code");

    if (!state.hasData) {
      log("State has no data. Returning false.");
      return false;
    }

    final referral = state.data![code];

    if (referral == null) {
      log("No referral found for code: $code. Returning false.");
      return false;
    }

    final valid =
        referral.referredId != null && referral.referredId!.isNotEmpty;

    if (!valid) {
      log("Referral found for code: $code, but it is already in use.");
    }

    log("Referral code $code is valid: $valid");

    return valid;
  }

  Future<String?> createReferral() async {
    log("Creating referral");

    if (!state.hasData) {
      log("State has no data. Aborting.");
      return null;
    }

    if (!auth.isAuthenticated) {
      log("User is not authenticated. Aborting.");
      return null;
    }

    final id = db.newDocumentId();

    final referral = Referral(
      id: id,
      creatorId: auth.currentUser!.uid,
    );

    try {
      await db.write(referral, id);

      log("Referral created with id: $id");

      return id;
    } catch (e, trace) {
      log("Error creating referral", e, trace);
      return null;
    }
  }

  Future<bool> signUpFirstUser({
    required String email,
    required String password,
    required String username,
  }) async {
    log("Creating first user");

    try {
      log("Creating user...");
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      log("Successfully created first user");
    } catch (e, trace) {
      log("Error creating user", e, trace);
      return false;
    }

    log("Sign up complete.");

    log("Setting username: $username");
    await userRepository.signIn(email, password);
    await userRepository.setUsermame(username);

    return true;
  }

  Future<bool> signUp({
    required String code,
    required String email,
    required String password,
    required String username,
  }) async {
    log("Creating user with referral code: $code");

    if (!state.hasData) {
      log("State has no data. Aborting.");
      return false;
    }

    if (!validateReferralCode(code)) {
      log("Invalid referral code: $code. Aborting.");
      return false;
    }

    var referral = state.data![code]!;
    String id = "";

    try {
      log("Creating user...");
      final user = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      id = user.user!.uid;

      log("Successfully created user with id: $id");
    } catch (e, trace) {
      log("Error creating user", e, trace);
      return false;
    }

    referral = referral.copyWith(referredId: id);

    try {
      log("Invaidating referral code: $code");
      await db.write(referral, referral.id);
      log("Referral code $code invalidated");
    } catch (e, trace) {
      log("Error invalidating referral code", e, trace);
      return false;
    }

    log("Sign up complete.");

    log("Setting username: $username");
    await userRepository.signIn(email, password);
    await userRepository.setUsermame(username);

    return true;
  }

  @override
  void dispose() {}
}
