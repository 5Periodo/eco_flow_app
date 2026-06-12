import 'package:flutter/material.dart';
import '../../colors/app_colors.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String points;
  final IconData icon;
  final Color iconColor;

  const CategoryCard({
    super.key,
    required this.title,
    required this.points,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:    const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:        AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:    const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color:        Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 28),
              ),
              Container(
                padding:    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color:        AppColors.primaryButton.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$points pts',
                  style: const TextStyle(
                    color:      AppColors.primaryButton,
                    fontWeight: FontWeight.bold,
                    fontSize:   12,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              color:      Colors.white,
              fontWeight: FontWeight.bold,
              fontSize:   18,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'DISPONÍVEL',
            style: TextStyle(
              color:       Colors.white38,
              fontSize:    10,
              fontWeight:  FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 3,
            width:  40,
            decoration: BoxDecoration(
              color:        Colors.white12,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}