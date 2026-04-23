import '../models/ranking_user.dart';
import 'mock_database.dart';

class MockRankingDataSource {
  final MockDatabase _db;
  MockRankingDataSource(this._db);

  Future<List<RankingUser>> fetchRanking({bool isFull = false}) async {
    await Future.delayed(const Duration(milliseconds: 800));

    int userRank = 42;
    if (_db.userPoints > 1200){
      userRank = 1;
    }      
    else if (_db.userPoints > 1000){
      userRank = 2;
    }  
    else if (_db.userPoints > 890){
      userRank = 3;
    } 

    final ranking = <RankingUser>[
      const RankingUser(rank: 1, name: 'Ana',   apartment: 'Apto 304', points: 1200),
      const RankingUser(rank: 2, name: 'Pedro', apartment: 'Apto 201', points: 1000),
      const RankingUser(rank: 3, name: 'Luana', apartment: 'Apto 502', points: 890),
    ];

    if (isFull) {
      ranking.addAll(const [
        RankingUser(rank: 4,  name: 'Carlos',  apartment: 'Apto 101', points: 850),
        RankingUser(rank: 5,  name: 'Mariana', apartment: 'Apto 405', points: 720),
        RankingUser(rank: 6,  name: 'João',    apartment: 'Apto 202', points: 610),
        RankingUser(rank: 7,  name: 'Sofia',   apartment: 'Apto 503', points: 500),
        RankingUser(rank: 8,  name: 'Rafael',  apartment: 'Apto 302', points: 450),
        RankingUser(rank: 9,  name: 'Isabela', apartment: 'Apto 404', points: 300),
        RankingUser(rank: 10, name: 'Gustavo', apartment: 'Apto 101', points: 150),
      ]);
    }

    ranking.add(RankingUser(
      rank:          userRank,
      name:          _db.userName,
      apartment:     _db.userApartment,
      points:        _db.userPoints,
      isCurrentUser: true,
    ));

    return ranking;
  }
}