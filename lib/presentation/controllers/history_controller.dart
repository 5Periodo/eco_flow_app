import 'package:flutter/material.dart';
import '../../domain/repositories/i_descarte_repository.dart';
import '../../domain/repositories/i_coupon_repository.dart';
import '../../data/models/user_profile.dart' show RecentDescarte;
import '../../data/models/reward_history.dart';

class HistoryController extends ChangeNotifier {
  final IDescarteRepository _descarteRepository;
  final ICouponRepository _couponRepository;

  HistoryController(this._descarteRepository, this._couponRepository);

  bool isLoading = false;
  String? errorMessage;

  List<RecentDescarte> descartes = [];
  List<RewardHistory> resgates = [];

  Future<void> loadHistories() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final futures = await Future.wait([
        _descarteRepository.getHistorico(),
        _couponRepository.getHistorico(),
      ]);

      descartes = futures[0] as List<RecentDescarte>;
      resgates = futures[1] as List<RewardHistory>;
    } on Exception catch (e) {
      errorMessage = 'Erro ao carregar histórico: ${e.toString()}';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}