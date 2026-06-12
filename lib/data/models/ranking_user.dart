class RankingUser {
  final int?   posicao;
  final String moradorNome;
  final String apartamentoNumero;
  final int    pontosTotal;
  final double totalKg;
  final int    coletas;

  const RankingUser({
    required this.posicao,
    required this.moradorNome,
    required this.apartamentoNumero,
    required this.pontosTotal,
    required this.totalKg,
    required this.coletas,
  });

  factory RankingUser.fromJson(Map<String, dynamic> json) => RankingUser(
      posicao:           json['posicao']           as int?,
        moradorNome:       json['moradorNome']       as String,
        apartamentoNumero: json['apartamentoNumero'] as String,
        pontosTotal:       json['pontosTotal']       as int,
        totalKg:           (json['totalKg']          as num).toDouble(),
        coletas:           json['coletas']           as int,
      );
}
