import 'package:mcquenji_firebase/mcquenji_firebase.dart';
import 'package:shopping_list/modules/auth/auth.dart';

class ReferralsDataSource extends TypedFirebaseFirestoreDataSource<Referral> {
  ReferralsDataSource({required super.db}) : super(collectionPath: "referrals");

  @override
  Referral deserialize(Map<String, dynamic> data) => Referral.fromJson(data);

  @override
  Map<String, dynamic> serialize(Referral data) => data.toJson();
}
