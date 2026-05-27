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
        id: json['id'] as int,
        nome: json['nome'] as String,
        multiplicadorPontos: _readNumericField(
          json,
          const ['multiplicadorPontos', 'pontosPorKg'],
        ),
        icone: (json['icone'] as String?) ?? 'recycling',
        cor: (json['cor'] as String?) ?? _defaultColorFor(json['nome'] as String?),
      );

  static double _readNumericField(
    Map<String, dynamic> json,
    List<String> keys,
  ) {
    for (final key in keys) {
      final value = json[key];
      if (value is num) {
        return value.toDouble();
      }
    }

    throw const FormatException('CategoriaMaterial sem campo numérico de pontos');
  }

  static String _defaultColorFor(String? nome) {
    final value = (nome ?? '').toLowerCase();
    if (value.contains('plástico') || value.contains('plastico')) return '#6BAA75';
    if (value.contains('papel')) return '#D9B26F';
    if (value.contains('vidro')) return '#7DB9D3';
    if (value.contains('metal') || value.contains('alumínio') || value.contains('aluminio')) {
      return '#9A9A9A';
    }
    if (value.contains('orgânico') || value.contains('organico')) return '#7A9E7E';
    return '#4CAF50';
  }
}
