import '../../domain/repositories/i_coupon_repository.dart';
import '../datasources/remote/recompensa_remote_data_source.dart';
import '../models/coupon.dart';
import '../models/reward_history.dart';

class CouponRepository implements ICouponRepository {
  final RecompensaRemoteDataSource _remote;
  final _redeemedIds = <String>{};

  CouponRepository(this._remote);

  @override
  Future<List<Coupon>> getCoupons() => _remote.fetchAll();

  @override
  Future<List<RewardHistory>> getHistorico() => _remote.fetchHistorico();

  @override
  Future<String> redeemCoupon(Coupon coupon) async {
    final code = await _remote.resgatar(coupon.id);
    _redeemedIds.add(coupon.id);
    return code;
  }

  @override
  bool isRedeemed(String couponId) => _redeemedIds.contains(couponId);
}
