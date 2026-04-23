import '../../domain/repositories/i_auth_repository.dart';
import '../datasources/mock_auth_data_source.dart';

class AuthRepository implements IAuthRepository {
  final MockAuthDataSource _dataSource;
  AuthRepository(this._dataSource);

  @override
  Future<bool> login(String email, String password) =>
      _dataSource.login(email, password);
}