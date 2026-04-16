import 'coupon.dart';
import 'mocker_database.dart';

class CouponService {
  // Retorna a lista de cupons disponíveis
  Future<List<Coupon>> getCoupons() async {
    await Future.delayed(const Duration(milliseconds: 800)); // Simula loading
    
    return [
      Coupon(id: '1', title: 'Desconto na Taxa', benefit: 'R\$ 50 OFF', description: 'Desconto direto na taxa do condomínio', cost: 1000),
      Coupon(id: '2', title: 'Café Gourmet', benefit: 'Café Grátis', description: 'Um café premium grátis', cost: 300),
      Coupon(id: '3', title: 'Cinema Parceiro', benefit: 'Meia Entrada', description: 'Ingresso com 50% de desconto', cost: 500),
    ];
  }

  // Lógica de resgatar o cupom
  Future<String?> redeemCoupon(Coupon coupon) async {
    await Future.delayed(const Duration(seconds: 1));
    final db = MockDatabase();

    // Verifica se tem pontos suficientes
    if (db.userPoints >= coupon.cost) {
      db.userPoints -= coupon.cost; // Desconta os pontos!
      db.redeemedCoupons.add(coupon.id); // Salva que já foi resgatado
      
      // Gera um código aleatório falso (ex: ECO-1A2B3C)
      String randomCode = DateTime.now().millisecondsSinceEpoch.toRadixString(16).toUpperCase();
      return "ECO-${randomCode.substring(randomCode.length - 6)}";
    }
    
    return null; // Retorna nulo se não tiver pontos
  }

  // Verifica se um cupom específico já foi resgatado
  bool isRedeemed(String couponId) {
    return MockDatabase().redeemedCoupons.contains(couponId);
  }
}