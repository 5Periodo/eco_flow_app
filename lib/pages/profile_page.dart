import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../colors/app_colors.dart';
import '../../presentation/controllers/profile_controller.dart';
import '../../data/models/user_profile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileController>(
      builder: (context, controller, _) {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primaryButton));
        }

        if (controller.profile == null) {
          return Center(
            child: Text(
              controller.errorMessage ?? 'Erro ao carregar perfil.',
              style: const TextStyle(color: Colors.white),
            ),
          );
        }

        return _ProfileContent(user: controller.profile!);
      },
    );
  }
}

class _ProfileContent extends StatelessWidget {
  final UserProfile user;
  const _ProfileContent({required this.user});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        children: [
          _Avatar(),
          const SizedBox(height: 16),
          Text(user.name,
              style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            padding:    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(20)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_on_outlined, color: Colors.white54, size: 16),
                const SizedBox(width: 6),
                Text(user.apartment, style: const TextStyle(color: Colors.white54, fontSize: 14)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {},
            icon:  const Icon(Icons.edit, color: Colors.white, size: 18),
            label: const Text('Editar Perfil',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.cardBackground,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape:   RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
          ),
          const SizedBox(height: 40),
          _BalanceCard(points: user.points),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon:      Icons.calendar_today,
                  iconColor: Colors.blue,
                  value:     '${user.collectionsMonth}',
                  label:     'COLETAS NO MÊS',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _StatCard(
                  icon:      Icons.local_fire_department,
                  iconColor: Colors.orange,
                  value:     '${user.streakDays} dias',
                  label:     'OFENSIVA ATUAL',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width:  100,
          height: 100,
          decoration: BoxDecoration(
            shape:  BoxShape.circle,
            color:  AppColors.cardBackground,
            border: Border.all(color: const Color(0xFF1A635D), width: 3),
          ),
          child: const Icon(Icons.person_outline, color: Colors.white54, size: 50),
        ),
        Container(
          padding:    const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color:  AppColors.primaryButton,
            shape:  BoxShape.circle,
            border: Border.all(color: AppColors.background, width: 3),
          ),
          child: const Icon(Icons.camera_alt, color: Colors.black, size: 16),
        ),
      ],
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final int points;
  const _BalanceCard({required this.points});

  @override
  Widget build(BuildContext context) {
    String nivel      = 'Iniciante';
    int proximoNivel  = 100;
    if (points >= 100) { nivel = 'Engajado';   proximoNivel = 300; }
    if (points >= 300) { nivel = 'Eco Master'; proximoNivel = 1000; }

    final faltam    = proximoNivel - points;
    final progresso = (points / proximoNivel).clamp(0.0, 1.0);

    return Container(
      width:   double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color:        AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Saldo Atual', style: TextStyle(color: Colors.white54, fontSize: 16)),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline:       TextBaseline.alphabetic,
            children: [
              Text('$points',
                  style: const TextStyle(
                      color: AppColors.primaryButton, fontSize: 48, fontWeight: FontWeight.bold, height: 1)),
              const SizedBox(width: 4),
              const Text('pts', style: TextStyle(color: Colors.white54, fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 30),
          Container(
            padding:    const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFF0A2E2A), borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      const Icon(Icons.shield_outlined, color: AppColors.primaryButton, size: 18),
                      const SizedBox(width: 6),
                      Text(nivel, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ]),
                    Text('Faltam $faltam pts',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value:           progresso,
                    backgroundColor: AppColors.cardBackground,
                    valueColor:      const AlwaysStoppedAnimation<Color>(Colors.white),
                    minHeight:       8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:    const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        children: [
          Container(
            padding:    const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(height: 16),
          Text(value,
              style: const TextStyle(
                  color: AppColors.background, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color:         Colors.grey,
                  fontSize:      10,
                  fontWeight:    FontWeight.bold,
                  letterSpacing: 1.2)),
        ],
      ),
    );
  }
}