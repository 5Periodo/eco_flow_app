import 'package:dio/dio.dart';
import '../../../core/errors/app_exceptions.dart';
import '../../models/user_profile.dart';

class ProfileRemoteDataSource {
  final Dio _dio;
  ProfileRemoteDataSource(this._dio);

  Future<UserProfile> fetchProfile() async {
    try {
      final response = await _dio.get('/moradores/meu-perfil');
      return UserProfile.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw AuthException();
      throw NetworkException();
    }
  }

  Future<UserProfile> updateProfile(String name, String? password) async {
    try {
      final data = {
        'nome': name,
        if (password != null && password.isNotEmpty) 'novaSenha': password,
      };
      final response = await _dio.patch('/moradores/meu-perfil', data: data);
      return UserProfile.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw AuthException();
      if (e.response?.statusCode == 400) throw ValidationException();
      throw NetworkException();
    }
  }
}
