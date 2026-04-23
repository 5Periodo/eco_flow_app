import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../colors/app_colors.dart';
import '../../../data/models/coupon.dart';
import '../../presentation/controllers/coupon_controller.dart';

class CouponPage extends StatefulWidget {
  const CouponPage({super.key});

  @override
  State<CouponPage> createState() => _CouponPageState();
}

class _CouponPageState extends State<CouponPage> {
  @override
  void initState() {
    super.initState();
    // Registra callback ANTES do primeiro frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<CouponController>();
      controller.onRedeemSuccess = (code) {
        // Busca o cupom resgatado para passar ao modal
        final coupon = controller.coupons.firstWhere(
          (c) => !controller.isRedeemedCoupon(c.id),
          orElse: () => controller.coupons.first,
        );
        if (mounted) _showSuccessModal(coupon, code);
      };
    });
  }

  void _handleRedeem(Coupon coupon) {
    context.read<CouponController>().redeem(coupon);
  }

  void _showSuccessModal(Coupon coupon, String code) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: const Color(0xFF2B303A),
        shape:           RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        insetPadding:    const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon:        const Icon(Icons.close, color: Colors.grey),
                  onPressed:   () => Navigator.pop(context),
                  padding:     EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
              const Icon(Icons.auto_awesome, color: AppColors.primaryButton, size: 50),
              const SizedBox(height: 16),
              const Text('Cupom Resgatado!',
                  style: TextStyle(color: AppColors.primaryButton, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              Text(coupon.title,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(coupon.benefit, style: const TextStyle(color: Colors.white54, fontSize: 14)),
              const SizedBox(height: 24),
              Container(
                width:   double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                    color: const Color(0xFF1E2229), borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    const Text('SEU CÓDIGO DE RESGATE',
                        style: TextStyle(
                            color: Colors.white54, fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text(code,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 24, letterSpacing: 4, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width:  double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: code));
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Código copiado!'), backgroundColor: Colors.green));
                  },
                  icon:  const Icon(Icons.copy, color: Colors.white),
                  label: const Text('Copiar Código',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00C853),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Apresente este código no estabelecimento\nparceiro para garantir seu benefício.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white54, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CouponController>(
      builder: (context, controller, _) {
        // Exibe erro de autenticação/pontos via SnackBar
        if (controller.hasError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:         Text(controller.errorMessage!),
                backgroundColor: Colors.redAccent,
              ),
            );
          });
        }

        if (controller.isLoading && controller.coupons.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primaryButton));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              Container(
                padding:    const EdgeInsets.all(16),
                decoration: const BoxDecoration(color: AppColors.cardBackground, shape: BoxShape.circle),
                child: const Icon(Icons.local_activity_outlined, color: AppColors.primaryButton, size: 30),
              ),
              const SizedBox(height: 16),
              const Text('Meus Cupons',
                  style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Use seus pontos para resgatar\nbenefícios exclusivos',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white54, fontSize: 14)),
              const SizedBox(height: 30),
              ListView.separated(
                shrinkWrap: true,
                physics:    const NeverScrollableScrollPhysics(),
                itemCount:  controller.coupons.length,
                // ignore: unnecessary_underscores
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (_, index) {
                  final coupon     = controller.coupons[index];
                  final isRedeemed = controller.isRedeemedCoupon(coupon.id);
                  return _CouponCard(
                    coupon:      coupon,
                    isRedeemed:  isRedeemed,
                    isRedeeming: controller.isRedeeming,
                    onRedeem:    () => _handleRedeem(coupon),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CouponCard extends StatelessWidget {
  final Coupon coupon;
  final bool isRedeemed;
  final bool isRedeeming;
  final VoidCallback onRedeem;

  const _CouponCard({
    required this.coupon,
    required this.isRedeemed,
    required this.isRedeeming,
    required this.onRedeem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:    const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: AppColors.cardBackground, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:  MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(coupon.title,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(coupon.benefit,
                        style: const TextStyle(
                            color: AppColors.primaryButton, fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Container(
                padding:    const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: const Color(0xFF0D3B36), borderRadius: BorderRadius.circular(12)),
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
                  const Icon(Icons.local_activity_outlined, color: AppColors.primaryButton, size: 16),
                  const SizedBox(width: 6),
                  Text('${coupon.cost} pts',
                      style: const TextStyle(
                          color: AppColors.primaryButton, fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
              isRedeemed
                  ? const Row(
                      children: [
                        Icon(Icons.check_circle_outline, color: Colors.white54, size: 16),
                        SizedBox(width: 6),
                        Text('Resgatado', style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold)),
                      ],
                    )
                  : ElevatedButton(
                      onPressed: isRedeeming ? null : onRedeem,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryButton,
                        foregroundColor: const Color(0xFF0D3B36),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text('Resgatar', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}