import 'package:dio/dio.dart';
import '../../../core/errors/app_exceptions.dart';
import '../../models/auth_token.dart';

class AuthRemoteDataSource {
  final Dio _dio;
  AuthRemoteDataSource(this._dio);

  Future<AuthToken> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login/morador',
        data: {'email': email, 'senha': password},
      );
      return AuthToken.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw AuthException();
      throw NetworkException();
    }
  }
}
