import 'package:flutter/material.dart';

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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF134D48), // Fundo verde escuro do card
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Linha do Ícone e da Tag de Pontos
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fundo branco do Ícone
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 28),
              ),
              // Tag Verde de Pontos (Ex: "10 pts")
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF86E33F).withValues(alpha: 0.2), // Fundo verde transparente
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "$points pts",
                  style: const TextStyle(
                    color: Color(0xFF86E33F),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          
          const Spacer(), // Empurra os textos lá para baixo
          
          // Título (Ex: "Plástico")
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          
          const SizedBox(height: 4),
          
          // Subtítulo
          const Text(
            "DISPONÍVEL",
            style: TextStyle(
              color: Colors.white38,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Aquela barrinha sutil de enfeite no fundo do card
          Container(
            height: 3,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}