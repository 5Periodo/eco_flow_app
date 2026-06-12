import '../../data/models/coupon.dart';
import '../../data/models/reward_history.dart';

abstract interface class ICouponRepository {
  Future<List<Coupon>> getCoupons();
  Future<List<RewardHistory>> getHistorico();
  Future<String> redeemCoupon(Coupon coupon);
  bool isRedeemed(String couponId);
}