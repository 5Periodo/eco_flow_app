import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../colors/app_colors.dart';
import '../../data/models/ranking_user.dart';
import '../../presentation/controllers/ranking_controller.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<RankingController>().loadRanking();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RankingController>(
      builder: (context, controller, _) {
        if (controller.isLoading) {
          return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryButton));
        }

        if (controller.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.wifi_off_outlined, color: Colors.white54, size: 48),
                const SizedBox(height: 12),
                Text(controller.errorMessage!,
                    style: const TextStyle(color: Colors.white54)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed:  controller.loadRanking,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryButton),
                  child: const Text('Tentar novamente'),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Cabeçalho ──
              const Row(
                children: [
                  Icon(Icons.emoji_events_outlined,
                      color: AppColors.primaryButton, size: 32),
                  SizedBox(width: 12),
                  Text('Ranking do Mês',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                '${controller.rankingList.length} de ${controller.totalCount} participantes',
                style: const TextStyle(color: Colors.white38, fontSize: 13),
              ),
              if (controller.myRanking != null) ...[
                const SizedBox(height: 16),
                _MyRankingCard(user: controller.myRanking!),
              ],
              const SizedBox(height: 24),

              // ── Lista ──
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        itemCount:      controller.rankingList.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder:   (_, i) =>
                            _RankingItem(user: controller.rankingList[i]),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Botão expandir / recolher ──
                    TextButton(
                      onPressed: controller.toggleFullRanking,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 32),
                        backgroundColor: AppColors.cardBackground,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            controller.isFullRanking
                                ? 'Ocultar'
                                : 'Ver Ranking Completo',
                            style: const TextStyle(
                                color:      AppColors.primaryButton,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            controller.isFullRanking
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: AppColors.primaryButton,
                            size:  18,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MyRankingCard extends StatelessWidget {
  final RankingUser user;

  const _MyRankingCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryButton.withValues(alpha: 0.35), width: 1.2),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primaryButton.withValues(alpha: 0.16),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              user.posicao != null ? '${user.posicao}º' : '--',
              style: const TextStyle(
                color: AppColors.primaryButton,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sua posição no ranking',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  user.posicao != null
                      ? 'Apto ${user.apartamentoNumero}'
                      : 'Posição ainda indisponível',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${user.pontosTotal} pts',
                style: const TextStyle(
                  color: AppColors.primaryButton,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${user.totalKg.toStringAsFixed(1)} kg',
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Item do ranking ──────────────────────────────────────────────────────────
class _RankingItem extends StatelessWidget {
  final RankingUser user;
  const _RankingItem({required this.user});

  Color get _medalColor {
    return switch (user.posicao ?? 0) {
      1 => Colors.amber,
      2 => Colors.grey.shade400,
      3 => Colors.orange.shade300,
      _ => Colors.white38,
    };
  }

  @override
  Widget build(BuildContext context) {
    final isTop3 = (user.posicao ?? 0) <= 3;

    return Container(
      padding:    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color:        AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: isTop3
            ? Border.all(color: _medalColor.withValues(alpha: 0.35), width: 1.5)
            : null,
      ),
      child: Column(
        children: [
          // ── Linha principal ──
          Row(
            children: [
              // Badge de posição
              SizedBox(
                width: 36,
                child: Center(
                  child: isTop3
                      ? Icon(Icons.emoji_events, color: _medalColor, size: 26)
                      : Text(
                        '${user.posicao ?? 0}º',
                          style: TextStyle(
                              color:      _medalColor,
                              fontWeight: FontWeight.bold,
                              fontSize:   15),
                        ),
                ),
              ),
              const SizedBox(width: 12),

              // Avatar com inicial
              CircleAvatar(
                radius:          20,
                backgroundColor: isTop3
                    ? _medalColor.withValues(alpha: 0.2)
                    : Colors.white12,
                child: Text(
                  user.moradorNome.isNotEmpty
                      ? user.moradorNome[0].toUpperCase()
                      : '?',
                  style: TextStyle(
                      color:      isTop3 ? _medalColor : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize:   16),
                ),
              ),
              const SizedBox(width: 12),

              // Nome + Apartamento
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.moradorNome,
                      style: const TextStyle(
                          color:      Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize:   15),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Apto ${user.apartamentoNumero}',
                      style: const TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ),
              ),

              // Pontos
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${user.pontosTotal}',
                    style: TextStyle(
                        color:      isTop3 ? _medalColor : AppColors.primaryButton,
                        fontWeight: FontWeight.bold,
                        fontSize:   20),
                  ),
                  const Text('PTS',
                      style: TextStyle(
                          color:      Colors.white38,
                          fontSize:   10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5)),
                ],
              ),
            ],
          ),

          // ── Linha de stats (kg + coletas) ──
          const SizedBox(height: 10),
          Container(
            padding:    const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color:        Colors.white.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatChip(
                  icon:  Icons.scale_outlined,
                  label: '${user.totalKg.toStringAsFixed(1)} kg',
                  color: AppColors.primaryButton,
                ),
                Container(width: 1, height: 18, color: Colors.white12),
                _StatChip(
                  icon:  Icons.recycling,
                  label: '${user.coletas} coleta${user.coletas != 1 ? 's' : ''}',
                  color: Colors.white54,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String   label;
  final Color    color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 5),
        Text(label,
            style: TextStyle(
                color:      color,
                fontSize:   12,
                fontWeight: FontWeight.w500)),
      ],
    );
  }
}

