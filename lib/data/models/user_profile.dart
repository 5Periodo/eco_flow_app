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
    final collectionsApproved =
        descartes.where((d) => (d as Map)['status'] == 'APROVADO').length;

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
    );
  }
}
