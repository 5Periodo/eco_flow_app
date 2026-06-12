import '../models/ranking_user.dart';
import 'mock_database.dart';

class MockRankingDataSource {
  MockRankingDataSource(MockDatabase _);

  Future<List<RankingUser>> fetchRanking({bool isFull = false}) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final ranking = <RankingUser>[
      const RankingUser(posicao: 1, moradorNome: 'Ana',   apartamentoNumero: '304', pontosTotal: 1200, totalKg: 12.0, coletas: 8),
      const RankingUser(posicao: 2, moradorNome: 'Pedro', apartamentoNumero: '201', pontosTotal: 1000, totalKg: 10.0, coletas: 7),
      const RankingUser(posicao: 3, moradorNome: 'Luana', apartamentoNumero: '502', pontosTotal: 890,  totalKg: 8.5,  coletas: 6),
    ];

    if (isFull) {
      ranking.addAll(const [
        RankingUser(posicao: 4,  moradorNome: 'Carlos',  apartamentoNumero: '101', pontosTotal: 850, totalKg: 8.0, coletas: 5),
        RankingUser(posicao: 5,  moradorNome: 'Mariana', apartamentoNumero: '405', pontosTotal: 720, totalKg: 7.0, coletas: 4),
        RankingUser(posicao: 6,  moradorNome: 'João',    apartamentoNumero: '202', pontosTotal: 610, totalKg: 6.0, coletas: 4),
        RankingUser(posicao: 7,  moradorNome: 'Sofia',   apartamentoNumero: '503', pontosTotal: 500, totalKg: 5.0, coletas: 3),
        RankingUser(posicao: 8,  moradorNome: 'Rafael',  apartamentoNumero: '302', pontosTotal: 450, totalKg: 4.5, coletas: 3),
        RankingUser(posicao: 9,  moradorNome: 'Isabela', apartamentoNumero: '404', pontosTotal: 300, totalKg: 3.0, coletas: 2),
        RankingUser(posicao: 10, moradorNome: 'Gustavo', apartamentoNumero: '101', pontosTotal: 150, totalKg: 1.5, coletas: 1),
      ]);
    }

    return ranking;
  }
}
