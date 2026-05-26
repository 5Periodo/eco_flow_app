import '../../domain/repositories/i_ranking_repository.dart';
import '../datasources/remote/ranking_remote_data_source.dart';
import '../models/ranking_user.dart';

class RankingRepository implements IRankingRepository {
  final RankingRemoteDataSource _remote;
  RankingRepository(this._remote);

  @override
  Future<List<RankingUser>> getRanking() => _remote.fetchRankingMensal();
}
