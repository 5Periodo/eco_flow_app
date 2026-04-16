import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import '../controller/coupon_controller.dart';
import '../Models/coupon_service.dart'; // <-- Aqui é onde o seu serviço realmente está!
import '../Models/coupon.dart';

class CouponPage extends StatefulWidget {
  const CouponPage({super.key});

  @override
  State<CouponPage> createState() => _CouponPageState();
}

class _CouponPageState extends State<CouponPage> {
  late final CouponController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CouponController(CouponService());
    _controller.loadCoupons();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleRedeem(Coupon coupon) async {
    if (_controller.currentPoints < coupon.cost) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pontos insuficientes para este cupom!", style: TextStyle(color: Colors.white)), backgroundColor: Colors.red),
      );
      return;
    }

    final code = await _controller.redeem(coupon);
    
    if (code != null && mounted) {
      _showSuccessModal(coupon, code);
    }
  }

  void _showSuccessModal(Coupon coupon, String code) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF2B303A), // Cor escura do seu modal
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        insetPadding: const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
              const Icon(Icons.auto_awesome, color: Color(0xFF86E33F), size: 50),
              const SizedBox(height: 16),
              const Text("Cupom Resgatado!", style: TextStyle(color: Color(0xFF86E33F), fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              Text(coupon.title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(coupon.benefit, style: const TextStyle(color: Colors.white54, fontSize: 14)),
              const SizedBox(height: 24),
              
              // CAIXA DO CÓDIGO
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(color: const Color(0xFF1E2229), borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    const Text("SEU CÓDIGO DE RESGATE", style: TextStyle(color: Colors.white54, fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text(code, style: const TextStyle(color: Colors.white, fontSize: 24, letterSpacing: 4, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              // BOTÃO COPIAR
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: code));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Código copiado!"), backgroundColor: Colors.green));
                  },
                  icon: const Icon(Icons.copy, color: Colors.white),
                  label: const Text("Copiar Código", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00C853), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                ),
              ),
              const SizedBox(height: 16),
              const Text("Apresente este código no\nestabelecimento parceiro para garantir\nseu benefício.", textAlign: TextAlign.center, style: TextStyle(color: Colors.white54, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Força a atualização da tela caso o usuário tenha ganhado pontos e mudado de aba
    _controller.loadCoupons();

    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        if (_controller.isLoading && _controller.coupons.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF86E33F)));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFF134D48), shape: BoxShape.circle),
                child: const Icon(Icons.local_activity_outlined, color: Color(0xFF86E33F), size: 30),
              ),
              const SizedBox(height: 16),
              const Text("Meus Cupons", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text("Use seus pontos para resgatar\nbenefícios exclusivos", textAlign: TextAlign.center, style: TextStyle(color: Colors.white54, fontSize: 14)),
              const SizedBox(height: 30),
              
              // LISTA DE CUPONS
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _controller.coupons.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final coupon = _controller.coupons[index];
                  final isRedeemed = _controller.checkIsRedeemed(coupon.id);
                  
                  return _buildCouponCard(coupon, isRedeemed);
                },
              ),
            ],
          ),
        );
      }
    );
  }

  Widget _buildCouponCard(Coupon coupon, bool isRedeemed) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF134D48),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(coupon.title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(coupon.benefit, style: const TextStyle(color: Color(0xFF86E33F), fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: const Color(0xFF0D3B36), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.qr_code, color: Colors.white54),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(coupon.description, style: const TextStyle(color: Colors.white54, fontSize: 12)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.local_activity_outlined, color: Color(0xFF86E33F), size: 16),
                  const SizedBox(width: 6),
                  Text("${coupon.cost} pts", style: const TextStyle(color: Color(0xFF86E33F), fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
              
              // SE JÁ FOI RESGATADO MOSTRA TEXTO, SENÃO MOSTRA BOTÃO
              isRedeemed
                  ? const Row(
                      children: [
                        Icon(Icons.check_circle_outline, color: Colors.white54, size: 16),
                        SizedBox(width: 6),
                        Text("Resgatado", style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold)),
                      ],
                    )
                  : ElevatedButton(
                      onPressed: _controller.isRedeeming ? null : () => _handleRedeem(coupon),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF86E33F),
                        foregroundColor: const Color(0xFF0D3B36),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text("Resgatar", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}