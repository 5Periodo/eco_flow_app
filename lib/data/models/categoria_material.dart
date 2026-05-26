class CategoriaMaterial {
  final int id;
  final String nome;
  final double multiplicadorPontos;
  final String icone;
  final String cor;

  const CategoriaMaterial({
    required this.id,
    required this.nome,
    required this.multiplicadorPontos,
    required this.icone,
    required this.cor,
  });

  factory CategoriaMaterial.fromJson(Map<String, dynamic> json) =>
      CategoriaMaterial(
        id:                  json['id']                  as int,
        nome:                json['nome']                as String,
        multiplicadorPontos: (json['multiplicadorPontos'] as num).toDouble(),
        icone:               json['icone']               as String,
        cor:                 json['cor']                 as String,
      );
}
