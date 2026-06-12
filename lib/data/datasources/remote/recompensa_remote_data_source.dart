import 'package:dio/dio.dart';
import '../../../core/errors/app_exceptions.dart';
import '../../models/coupon.dart';
import '../../models/reward_history.dart';

class RecompensaRemoteDataSource {
  final Dio _dio;
  RecompensaRemoteDataSource(this._dio);

  Future<List<Coupon>> fetchAll() async {
    try {
      final response = await _dio.get('/recompensas');
      final list = response.data as List<dynamic>;
      return list.map((e) => Coupon.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw AuthException();
      throw NetworkException();
    }
  }

  Future<String> resgatar(String id) async {
    try {
      final response = await _dio.post('/recompensas/$id/resgatar');
      return response.data['codigoCupom'] as String;
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 401) throw AuthException();
      if (status == 400) throw InsufficientPointsException();
      if (status == 409) throw CouponAlreadyRedeemedException();
      throw NetworkException();
    }
  }

  Future<List<RewardHistory>> fetchHistorico() async {
    try {
      final response = await _dio.get('/recompensas/meu-historico-resgates');
      final list = response.data as List<dynamic>;
      return list.map((e) => RewardHistory.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw AuthException();
      throw NetworkException();
    }
  }
}
