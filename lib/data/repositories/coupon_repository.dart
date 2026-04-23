import '../../domain/repositories/i_coupon_repository.dart';
import '../datasources/mock_coupon_data_source.dart';
import '../models/coupon.dart';

class CouponRepository implements ICouponRepository {
  final MockCouponDataSource _dataSource;
  CouponRepository(this._dataSource);

  @override
  Future<List<Coupon>> getCoupons() => _dataSource.fetchCoupons();

  @override
  Future<String> redeemCoupon(Coupon coupon) => _dataSource.redeem(coupon);

  @override
  bool isRedeemed(String couponId) => _dataSource.checkRedeemed(couponId);
}