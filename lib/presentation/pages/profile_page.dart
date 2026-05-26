import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../colors/app_colors.dart';
import '../../presentation/controllers/profile_controller.dart';
import '../../data/models/user_profile.dart';
import '../widgets/edit_profile_dialog.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ProfileController>().loadProfile();
      }
    });
  }

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

  IconData _iconForCategory(String icon) {
    switch (icon.toLowerCase()) {
      case 'metal':
        return Icons.build_outlined;
      case 'vidro':
        return Icons.local_bar_outlined;
      case 'plastico':
        return Icons.delete_outline;
      case 'papel':
        return Icons.description_outlined;
      case 'organico':
        return Icons.eco_outlined;
      default:
        return Icons.recycling;
    }
  }

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'APROVADO':
        return Colors.greenAccent;
      case 'PENDENTE':
        return Colors.orangeAccent;
      case 'NEGADO':
        return Colors.redAccent;
      default:
        return Colors.white54;
    }
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

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
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => EditProfileDialog(user: user),
              );
            },
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
          const SizedBox(height: 16),
          const Text('Sair da conta', style: TextStyle(color: Colors.redAccent)),
          const SizedBox(height: 40),
          _BalanceCard(user: user),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon:      Icons.check_circle_outline,
                  iconColor: Colors.blue,
                  value:     '${user.collectionsApproved}',
                  label:     'COLETAS APROVADAS',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _StatCard(
                  icon:      Icons.recycling,
                  iconColor: Colors.green,
                  value:     '${user.totalCollections}',
                  label:     'TOTAL DESCARTES',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Histórico recente',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/history'),
                child: const Text(
                  'Ver completo',
                  style: TextStyle(color: AppColors.primaryButton, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (user.recentDescartes.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Text(
                'Nenhum descarte registrado ainda.',
                style: TextStyle(color: Colors.white54),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: user.recentDescartes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, index) {
                final descarte = user.recentDescartes[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: _statusColor(descarte.status).withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _iconForCategory(descarte.categoryIcon),
                          color: _statusColor(descarte.status),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              descarte.categoryName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${descarte.weightKg.toStringAsFixed(1)} kg • ${_formatDate(descarte.date)}',
                              style: const TextStyle(color: Colors.white54, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${descarte.points} pts',
                            style: const TextStyle(
                              color: AppColors.primaryButton,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            descarte.status,
                            style: TextStyle(
                              color: _statusColor(descarte.status),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
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
  final UserProfile user;
  const _BalanceCard({required this.user});

  @override
  Widget build(BuildContext context) {
    final faltam    = user.nextLevelPoints != null ? user.nextLevelPoints! - user.points : 0;
    final progresso = user.nextLevelPoints != null
        ? (user.points / user.nextLevelPoints!).clamp(0.0, 1.0)
        : 1.0;

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
              Text('${user.points}',
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
                      Text(user.levelName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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