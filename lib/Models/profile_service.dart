import 'user_profile.dart';
import 'mocker_database.dart';

class ProfileService {
  Future<UserProfile> getUserData() async {
    await Future.delayed(const Duration(milliseconds: 800)); // Simulando loading rápido

    // Em vez de números fixos, pegamos do nosso Banco Falso!
    final db = MockDatabase(); 

    return UserProfile(
      name: db.userName,
      apartment: db.userApartment,
      points: db.userPoints,
      collectionsMonth: db.userCollectionsMonth,
      streakDays: db.userStreakDays,
    );
  }
}