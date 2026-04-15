class RankingUser {
  final int rank;
  final String name;
  final String apartment;
  final int points;
  final bool isCurrentUser;

  RankingUser({
    required this.rank,
    required this.name,
    required this.apartment,
    required this.points,
    this.isCurrentUser = false,
  });
}