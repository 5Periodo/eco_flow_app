import '../../domain/repositories/i_auth_repository.dart';
import '../../core/storage/secure_storage_service.dart';
import '../datasources/remote/auth_remote_data_source.dart';
import '../models/auth_token.dart';

class AuthRepository implements IAuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorageService _storage;

  AuthRepository(this._remoteDataSource, this._storage);

  @override
  Future<AuthToken> login(String email, String password) async {
    final token = await _remoteDataSource.login(email, password);
    await _storage.saveToken(token.accessToken);
    return token;
  }

  @override
  Future<void> logout() => _storage.deleteToken();

  @override
  Future<String?> getStoredToken() => _storage.getToken();
}
