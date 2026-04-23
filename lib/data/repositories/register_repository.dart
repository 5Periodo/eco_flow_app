import '../../domain/repositories/i_register_repository.dart';
import '../datasources/mock_register_data_source.dart';

class RegisterRepository implements IRegisterRepository {
  final MockRegisterDataSource _dataSource;
  RegisterRepository(this._dataSource);

  @override
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    String? block,
    required String apartment,
  }) =>
      _dataSource.register(
        name:      name,
        email:     email,
        password:  password,
        block:     block,
        apartment: apartment,
      );
}