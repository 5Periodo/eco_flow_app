import '../../data/models/coupon.dart';

abstract interface class ICouponRepository {
  Future<List<Coupon>> getCoupons();
  Future<String> redeemCoupon(Coupon coupon);
  bool isRedeemed(String couponId);
}