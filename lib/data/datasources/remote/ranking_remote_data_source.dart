import 'package:dio/dio.dart';
import '../../../core/errors/app_exceptions.dart';
import '../../models/ranking_user.dart';

class RankingRemoteDataSource {
  final Dio _dio;
  RankingRemoteDataSource(this._dio);

  Future<List<RankingUser>> fetchRankingMensal() async {
    try {
      final response = await _dio.get('/ranking/mensal');
      final list = response.data as List<dynamic>;
      return list
          .map((e) => RankingUser.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw AuthException();
      throw NetworkException();
    }
  }

  Future<RankingUser> fetchMeuRankingMensal() async {
    try {
      final response = await _dio.get('/ranking/me');
      return RankingUser.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw AuthException();
      throw NetworkException();
    }
  }
}
