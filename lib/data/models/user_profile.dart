class RecentDescarte {
  final String id;
  final String categoryName;
  final String categoryIcon;
  final String status;
  final double weightKg;
  final int points;
  final DateTime date;
  final String? ecopointName;
  final String? ecopointLocation;
  final List<String> fotoUrls;

  const RecentDescarte({
    required this.id,
    required this.categoryName,
    required this.categoryIcon,
    required this.status,
    required this.weightKg,
    required this.points,
    required this.date,
    this.ecopointName,
    this.ecopointLocation,
    this.fotoUrls = const [],
  });

  factory RecentDescarte.fromJson(Map<String, dynamic> json) {
    final categoria = json['categoriaMaterial'] as Map<String, dynamic>?;
    final rawPoints = json['pontosAtribuidos'] ?? json['pontosGerados'] ?? 0;

    final ecopoint = json['ecopoint'] as Map<String, dynamic>?;
    final fotos = json['fotoUrls'] as List<dynamic>?;

    return RecentDescarte(
      id: json['id'] as String,
      categoryName: categoria?['nome'] as String? ?? 'Material',
      categoryIcon: categoria?['icone'] as String? ?? 'recycling',
      status: json['status'] as String? ?? 'PENDENTE',
      weightKg: double.tryParse(json['pesoKg'].toString()) ?? 0,
      points: (rawPoints as num).toInt(),
      date: DateTime.tryParse(json['dataColeta'].toString()) ?? DateTime.now(),
      ecopointName: ecopoint?['descricao'] as String?,
      ecopointLocation: ecopoint?['localizacao'] as String?,
      fotoUrls: fotos?.map((e) => e.toString()).toList() ?? [],
    );
  }
}

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String apartment;
  final int points;
  final String levelName;
  final int collectionsApproved;
  final int totalCollections;
  final String? nextLevelName;
  final int? nextLevelPoints;
  final List<RecentDescarte> recentDescartes;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.apartment,
    required this.points,
    required this.levelName,
    required this.collectionsApproved,
    required this.totalCollections,
    this.nextLevelName,
    this.nextLevelPoints,
    required this.recentDescartes,
  });

  // Campos do backend: id, nome, email, pontosTotal, apartamento, nivel, proximoNivel, descartes
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final apto = json['apartamento'] as Map<String, dynamic>?;
    final apartment = apto != null
        ? 'Apto ${apto['numero']} - Bloco ${apto['bloco']}'
        : '';

    final nivel       = json['nivel']       as Map<String, dynamic>?;
    final proximoNivel = json['proximoNivel'] as Map<String, dynamic>?;

    final descartes = (json['descartes'] as List<dynamic>?) ?? [];
    final recentDescartes = descartes
      .whereType<Map<String, dynamic>>()
      .map(RecentDescarte.fromJson)
      .toList();
    final collectionsApproved =
      recentDescartes.where((d) => d.status == 'APROVADO').length;

    return UserProfile(
      id:                   json['id']          as String,
      name:                 json['nome']         as String,
      email:                json['email']        as String,
      apartment:            apartment,
      points:               json['pontosTotal']  as int,
      levelName:            nivel?['nome']       as String? ?? 'Iniciante',
      collectionsApproved:  collectionsApproved,
      totalCollections:     descartes.length,
      nextLevelName:        proximoNivel?['nome']          as String?,
      nextLevelPoints:      proximoNivel?['pontosMinimos'] as int?,
      recentDescartes:      recentDescartes,
    );
  }
}
