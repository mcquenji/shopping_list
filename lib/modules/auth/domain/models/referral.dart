import 'package:freezed_annotation/freezed_annotation.dart';

part 'referral.freezed.dart';
part 'referral.g.dart';

@freezed
class Referral with _$Referral {
  factory Referral({
    /// The unique identifier of this referral.
    required String id,

    /// The id of the user who created this referral.
    required String creatorId,

    /// The id of the user that registered using this referral.
    String? referredId,
  }) = _Referral;

  factory Referral.fromJson(Map<String, dynamic> json) =>
      _$ReferralFromJson(json);
}
