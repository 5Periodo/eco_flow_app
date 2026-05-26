import '../../domain/repositories/i_profile_repository.dart';
import '../datasources/remote/profile_remote_data_source.dart';
import '../models/user_profile.dart';

class ProfileRepository implements IProfileRepository {
  final ProfileRemoteDataSource _remote;
  ProfileRepository(this._remote);

  @override
  Future<UserProfile> getProfile() => _remote.fetchProfile();
}
