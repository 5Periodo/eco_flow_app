class RankingUser {
  final int rank;
  final String name;
  final String apartment;
  final int points;
  final bool isCurrentUser;

  const RankingUser({
    required this.rank,
    required this.name,
    required this.apartment,
    required this.points,
    this.isCurrentUser = false,
  });

  factory RankingUser.fromJson(Map<String, dynamic> json) => RankingUser(
        rank:          json['rank']          as int,
        name:          json['name']          as String,
        apartment:     json['apartment']     as String,
        points:        json['points']        as int,
        isCurrentUser: json['isCurrentUser'] as bool? ?? false,
      );
}