class Coupon {
  final String id;
  final String title;
  final String benefit;
  final String description;
  final int cost;

  const Coupon({
    required this.id,
    required this.title,
    required this.benefit,
    required this.description,
    required this.cost,
  });

  // Campos do backend: id, titulo, descricao, custoPontos, tipo, valorDesconto
  factory Coupon.fromJson(Map<String, dynamic> json) {
    final tipo          = json['tipo'] as String;
    // valorDesconto pode vir como String ("5") ou num — parseia de forma segura
    final valorDesconto = json['valorDesconto'] != null
        ? num.tryParse(json['valorDesconto'].toString())
        : null;

    final benefit = switch (tipo) {
      'DESCONTO_CONDOMINIO' when valorDesconto != null =>
        '${valorDesconto.toInt()}% OFF',
      'DESCONTO_CONDOMINIO' => 'Desconto no Condomínio',
      'CUPOM_PARCEIRO' when valorDesconto != null =>
        'R\$ ${valorDesconto.toInt()} OFF',
      'CUPOM_PARCEIRO'      => 'Cupom Parceiro',
      _                     => tipo,
    };

    return Coupon(
      id:          json['id']          as String,
      title:       json['titulo']      as String,
      benefit:     benefit,
      description: json['descricao']   as String,
      cost:        json['custoPontos'] as int,
    );
  }
}
