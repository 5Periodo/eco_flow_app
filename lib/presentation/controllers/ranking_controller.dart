import 'package:flutter/material.dart';
import '../../core/errors/app_exceptions.dart';
import '../../domain/repositories/i_ranking_repository.dart';
import '../../data/models/ranking_user.dart';

class RankingController extends ChangeNotifier {
  final IRankingRepository _repository;
  RankingController(this._repository);

  static const _previewCount = 5;

  List<RankingUser> _allRanking = [];
  List<RankingUser> rankingList = [];

  bool    isLoading     = false;
  bool    isFullRanking = false;
  String? errorMessage;

  Future<void> loadRanking() async {
    isLoading    = true;
    errorMessage = null;
    notifyListeners();

    try {
      _allRanking = await _repository.getRanking();
      _applyFilter();
    } on AuthException catch (e) {
      errorMessage = e.message;
    } on NetworkException catch (e) {
      errorMessage = e.message;
    } on Exception {
      errorMessage = 'Erro ao carregar ranking.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void toggleFullRanking() {
    isFullRanking = !isFullRanking;
    _applyFilter();
    notifyListeners();
  }

  int get totalCount => _allRanking.length;

  void _applyFilter() {
    rankingList = isFullRanking
        ? _allRanking
        : _allRanking.take(_previewCount).toList();
  }
}
