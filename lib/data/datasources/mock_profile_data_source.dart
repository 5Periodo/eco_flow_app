import '../models/user_profile.dart';
import 'mock_database.dart';

class MockProfileDataSource {
  final MockDatabase _db;
  MockProfileDataSource(this._db);

  Future<UserProfile> fetchProfile() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return UserProfile(
      name:             _db.userName,
      apartment:        _db.userApartment,
      points:           _db.userPoints,
      collectionsMonth: _db.userCollectionsMonth,
      streakDays:       _db.userStreakDays,
    );
  }
}