import '../models/coupon.dart';
import 'mock_database.dart';
import '../../core/errors/app_exceptions.dart';

class MockCouponDataSource {
  final MockDatabase _db;
  MockCouponDataSource(this._db);

  Future<List<Coupon>> fetchCoupons() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return const[
      Coupon(id: '1', title: 'Desconto na Taxa', benefit: 'R\$ 50 OFF',   description: 'Desconto direto na taxa do condomínio', cost: 1000),
      Coupon(id: '2', title: 'Café Gourmet',     benefit: 'Café Grátis',  description: 'Um café premium grátis',                cost: 300),
      Coupon(id: '3', title: 'Cinema Parceiro',  benefit: 'Meia Entrada', description: 'Ingresso com 50% de desconto',          cost: 500),
    ];
  }

  Future<String> redeem(Coupon coupon) async {
    await Future.delayed(const Duration(seconds: 1));

    if (_db.userPoints < coupon.cost)          throw InsufficientPointsException();
    if (_db.redeemedCoupons.contains(coupon.id)) throw CouponAlreadyRedeemedException();

    _db.deductPoints(coupon.cost);
    _db.addRedeemedCoupon(coupon.id);

    final raw = DateTime.now().millisecondsSinceEpoch.toRadixString(16).toUpperCase();
    return 'ECO-${raw.substring(raw.length - 6)}';
  }

  bool checkRedeemed(String id) => _db.redeemedCoupons.contains(id);
}