import '../../data/models/ranking_user.dart';

abstract interface class IRankingRepository {
  Future<List<RankingUser>> getRanking({bool isFull = false});
}