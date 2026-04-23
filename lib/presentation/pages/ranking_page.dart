import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../colors/app_colors.dart';
import '../../data/models/ranking_user.dart';
import '../../presentation/controllers/ranking_controller.dart';

class RankingPage extends StatelessWidget {
  const RankingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RankingController>(
      builder: (context, controller, _) {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primaryButton));
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.emoji_events_outlined, color: AppColors.primaryButton, size: 32),
                  SizedBox(width: 12),
                  Text('Ranking do Mês',
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 30),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        itemCount: controller.rankingList.length,
                        separatorBuilder: (_, index) {
                          if (index == controller.rankingList.length - 2) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Row(
                                children: [
                                  Expanded(child: Divider(color: Colors.white12)),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: Text('Sua Colocação',
                                        style: TextStyle(color: Colors.white54, fontSize: 12)),
                                  ),
                                  Expanded(child: Divider(color: Colors.white12)),
                                ],
                              ),
                            );
                          }
                          return const SizedBox(height: 12);
                        },
                        itemBuilder: (_, index) =>
                            _RankingItem(user: controller.rankingList[index]),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: controller.toggleFullRanking,
                      style: TextButton.styleFrom(
                        padding:         const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                        backgroundColor: AppColors.cardBackground,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            controller.isFullRanking ? 'Ocultar Ranking' : 'Ver Ranking Completo',
                            style: const TextStyle(
                                color: AppColors.primaryButton, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            controller.isFullRanking
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: AppColors.primaryButton,
                            size:  20,
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

class _RankingItem extends StatelessWidget {
  final RankingUser user;
  const _RankingItem({required this.user});

  Color get _rankColor {
    if (user.rank == 1) return Colors.amber;
    if (user.rank == 2) return Colors.grey.shade400;
    if (user.rank == 3) return Colors.orange.shade300;
    return Colors.white38;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:    const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:        user.isCurrentUser ? AppColors.cardBackground : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border:       user.isCurrentUser ? Border.all(color: Colors.white12) : null,
      ),
      child: Row(
        children: [
          Container(
            width:  40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: user.rank <= 3 ? _rankColor.withValues(alpha: 0.1) : Colors.transparent,
            ),
            child: Center(
              child: user.rank <= 3
                  ? Icon(Icons.emoji_events, color: _rankColor, size: 24)
                  : Text('${user.rank}º',
                      style: TextStyle(
                          color: _rankColor, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
          const SizedBox(width: 16),
          CircleAvatar(
            backgroundColor:
                user.isCurrentUser ? const Color(0xFF2E7D32) : Colors.white12,
            child: Text(
              user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                Text(user.apartment, style: const TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${user.points}',
                  style: const TextStyle(
                      color: AppColors.primaryButton, fontWeight: FontWeight.bold, fontSize: 20)),
              const Text('PTS',
                  style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}