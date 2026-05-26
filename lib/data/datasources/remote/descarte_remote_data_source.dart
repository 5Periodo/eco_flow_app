import 'package:dio/dio.dart';
import '../../../core/errors/app_exceptions.dart';
import '../../models/categoria_material.dart';
import '../../models/user_profile.dart'; // To use RecentDescarte

class DescarteRemoteDataSource {
  final Dio _dio;
  DescarteRemoteDataSource(this._dio);

  Future<List<CategoriaMaterial>> fetchCategorias() async {
    try {
      final response = await _dio.get('/categorias-material');
      final list = response.data as List<dynamic>;
      return list
          .map((e) => CategoriaMaterial.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw AuthException();
      throw NetworkException();
    }
  }

  Future<List<RecentDescarte>> fetchHistorico() async {
    try {
      final response = await _dio.get('/descartes/historico');
      final list = response.data as List<dynamic>;
      return list
          .map((e) => RecentDescarte.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw AuthException();
      throw NetworkException();
    }
  }

  Future<void> registrarDescarte({
    required String qrCodeHash,
    required int categoriaMaterialId,
    required double pesoKg,
  }) async {
    try {
      await _dio.post('/descartes/registrar', data: {
        'qrCodeHash':          qrCodeHash,
        'categoriaMaterialId': categoriaMaterialId,
        'pesoKg':              pesoKg,
      });
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw AuthException();
      throw NetworkException();
    }
  }
}
