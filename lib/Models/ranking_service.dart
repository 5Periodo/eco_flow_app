import 'ranking_user.dart';
import 'mocker_database.dart';

class RankingService {
  // Agora o serviço recebe um parâmetro (por padrão é falso)
  Future<List<RankingUser>> getRanking({bool isFull = false}) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final db = MockDatabase();
    int userRank = 42; 
    if (db.userPoints > 1200) userRank = 1;
    else if (db.userPoints > 1000) userRank = 2;
    else if (db.userPoints > 890) userRank = 3;

    List<RankingUser> ranking = [
      RankingUser(rank: 1, name: "Ana", apartment: "Apto 304", points: 1200),
      RankingUser(rank: 2, name: "Pedro", apartment: "Apto 201", points: 1000),
      RankingUser(rank: 3, name: "Luana", apartment: "Apto 502", points: 890),
    ];

    // SE O USUÁRIO CLICAR EM "VER COMPLETO", nós adicionamos mais pessoas!
    if (isFull) {
      ranking.addAll([
        RankingUser(rank: 4, name: "Carlos", apartment: "Apto 101", points: 850),
        RankingUser(rank: 5, name: "Mariana", apartment: "Apto 405", points: 720),
        RankingUser(rank: 6, name: "João", apartment: "Apto 202", points: 610),
        // Pode adicionar quantos quiser aqui para testar o scroll...
      ]);
    }

    // Adiciona o usuário logado sempre no final
    ranking.add(
      RankingUser(
        rank: userRank,
        name: db.userName,
        apartment: db.userApartment,
        points: db.userPoints,
        isCurrentUser: true,
      )
    );

    return ranking;
  }
}