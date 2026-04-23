import '../../domain/repositories/i_ranking_repository.dart';
import '../datasources/mock_ranking_data_source.dart';
import '../models/ranking_user.dart';

class RankingRepository implements IRankingRepository {
  final MockRankingDataSource _dataSource;
  RankingRepository(this._dataSource);

  @override
  Future<List<RankingUser>> getRanking({bool isFull = false}) =>
      _dataSource.fetchRanking(isFull: isFull);
}