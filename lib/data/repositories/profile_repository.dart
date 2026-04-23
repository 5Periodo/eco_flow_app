import '../../domain/repositories/i_profile_repository.dart';
import '../datasources/mock_profile_data_source.dart';
import '../models/user_profile.dart';

class ProfileRepository implements IProfileRepository {
  final MockProfileDataSource _dataSource;
  ProfileRepository(this._dataSource);

  @override
  Future<UserProfile> getProfile() => _dataSource.fetchProfile();
}