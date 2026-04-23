class InsufficientPointsException implements Exception {
  final String message = 'Pontos insuficientes para resgatar este cupom.';
}

class CouponAlreadyRedeemedException implements Exception {
  final String message = 'Cupom já foi resgatado.';
}

class AuthException implements Exception {
  final String message = 'Credenciais inválidas.';
}

class NetworkException implements Exception {
  final String message = 'Sem conexão. Tente novamente.';
}