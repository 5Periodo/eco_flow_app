class RewardHistory {
  final String id;
  final String status;
  final String verificationCode;
  final DateTime redeemedAt;
  final String title;
  final String type;
  final int pointsCost;

  const RewardHistory({
    required this.id,
    required this.status,
    required this.verificationCode,
    required this.redeemedAt,
    required this.title,
    required this.type,
    required this.pointsCost,
  });

  factory RewardHistory.fromJson(Map<String, dynamic> json) {
    final recompensa = json['recompensa'] as Map<String, dynamic>?;

    return RewardHistory(
      id: json['id'] as String,
      status: json['status'] as String? ?? 'PENDENTE',
      verificationCode: json['codigoCupom'] as String? ?? '',
      redeemedAt: DateTime.tryParse(json['resgatadoEm'].toString()) ?? DateTime.now(),
      title: recompensa?['titulo'] as String? ?? 'Recompensa',
      type: recompensa?['tipo'] as String? ?? 'DESCONTO',
      pointsCost: recompensa?['custoPontos'] as int? ?? 0,
    );
  }
}