import 'package:flutter/material.dart';
import '../../Models/ranking_user.dart';
import '../../Models/ranking_service.dart'; // Importando nosso Service!

class RankingController extends ChangeNotifier {
  final RankingService _service;

  RankingController(this._service);

  List<RankingUser> rankingList = [];
  bool isLoading = true;
  bool isFullRanking = false; // <-- Nova variável!

  Future<void> loadRanking() async {
    isLoading = true;
    notifyListeners();

    try {
      // Passa a variável para o serviço saber qual lista trazer
      rankingList = await _service.getRanking(isFull: isFullRanking);
    } catch (e) {
      debugPrint("Erro ao carregar ranking: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // <-- Nova função que o botão da tela vai chamar!
  void toggleFullRanking() {
    isFullRanking = !isFullRanking;
    loadRanking();
  }
}