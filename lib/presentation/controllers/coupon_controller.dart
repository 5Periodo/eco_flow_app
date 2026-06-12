import 'package:flutter/material.dart';
import '../../domain/repositories/i_coupon_repository.dart';
import '../../data/models/coupon.dart';
import '../../core/errors/app_exceptions.dart';

class CouponController extends ChangeNotifier {
  final ICouponRepository _repository;
  CouponController(this._repository);

  List<Coupon> coupons  = [];
  bool isLoading        = false;
  bool isRedeeming      = false;
  String? errorMessage;

  bool get hasError => errorMessage != null;

  /// Callback registrado pela View para reagir ao sucesso do resgate
  void Function(String code)? onRedeemSuccess;

  Future<void> loadCoupons() async {
    isLoading    = true;
    errorMessage = null;
    notifyListeners();

    try {
      coupons = await _repository.getCoupons();
    } on Exception {
      errorMessage = 'Não foi possível carregar os cupons.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> redeem(Coupon coupon) async {
    isRedeeming  = true;
    errorMessage = null;
    notifyListeners();

    try {
      final code = await _repository.redeemCoupon(coupon);
      onRedeemSuccess?.call(code);
    } on InsufficientPointsException catch (e) {
      errorMessage = e.message;
    } on CouponAlreadyRedeemedException catch (e) {
      errorMessage = e.message;
    } on Exception {
      errorMessage = 'Erro ao resgatar cupom.';
    } finally {
      isRedeeming = false;
      notifyListeners();
    }
  }

  bool isRedeemedCoupon(String id) => _repository.isRedeemed(id);
}