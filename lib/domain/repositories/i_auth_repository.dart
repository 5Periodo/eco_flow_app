import '../../data/models/auth_token.dart';

abstract interface class IAuthRepository {
  Future<AuthToken> login(String email, String password);
  Future<void> logout();
  Future<String?> getStoredToken();
}
