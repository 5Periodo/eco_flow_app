import 'package:flutter/material.dart';
import '../../domain/repositories/i_ranking_repository.dart';
import '../../data/models/ranking_user.dart';

class RankingController extends ChangeNotifier {
  final IRankingRepository _repository;
  RankingController(this._repository);

  List<RankingUser> rankingList = [];
  bool isLoading     = false;
  bool isFullRanking = false;
  String? errorMessage;

  Future<void> loadRanking() async {
    isLoading    = true;
    errorMessage = null;
    notifyListeners();

    try {
      rankingList = await _repository.getRanking(isFull: isFullRanking);
    } on Exception {
      errorMessage = 'Erro ao carregar ranking.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void toggleFullRanking() {
    isFullRanking = !isFullRanking;
    loadRanking();
  }
}