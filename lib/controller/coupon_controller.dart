import 'package:flutter/material.dart';
import '../Models/coupon.dart';
import '../Models/coupon_service.dart';
import '../Models/mocker_database.dart';

class CouponController extends ChangeNotifier {
  final CouponService _service;

  CouponController(this._service);

  List<Coupon> coupons = [];
  bool isLoading = true;
  bool isRedeeming = false; // Controle de loading do botão de resgatar

  // Getter rápido para a tela saber quantos pontos o usuário tem agora
  int get currentPoints => MockDatabase().userPoints;

  Future<void> loadCoupons() async {
    isLoading = true;
    notifyListeners();

    coupons = await _service.getCoupons();
    
    isLoading = false;
    notifyListeners();
  }

  bool checkIsRedeemed(String id) => _service.isRedeemed(id);

  Future<String?> redeem(Coupon coupon) async {
    isRedeeming = true;
    notifyListeners();

    final code = await _service.redeemCoupon(coupon);

    isRedeeming = false;
    notifyListeners();
    return code; // Retorna o código gerado para a tela mostrar no modal
  }
}