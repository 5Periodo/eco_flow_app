class UserProfile {
  final String name;
  final String apartment;
  final int points;
  final int collectionsMonth;
  final int streakDays;

  const UserProfile({
    required this.name,
    required this.apartment,
    required this.points,
    required this.collectionsMonth,
    required this.streakDays,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        name:              json['name']              as String,
        apartment:         json['apartment']         as String,
        points:            json['points']            as int,
        collectionsMonth:  json['collectionsMonth']  as int,
        streakDays:        json['streakDays']        as int,
      );
}