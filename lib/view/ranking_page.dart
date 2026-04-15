import 'package:flutter/material.dart';
import '../controller/ranking_controller.dart';
import '../Models/ranking_service.dart';
import '../Models/ranking_user.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  late final RankingController _controller;

  @override
  void initState() {
    super.initState();
    // Instancia o controller injetando o service
    _controller = RankingController(RankingService());
    // Pede para carregar o ranking assim que a tela abre
    _controller.loadRanking();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        // Mostra o loading enquanto busca os dados
        if (_controller.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF86E33F)),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TÍTULO DA TELA
              const Row(
                children: [
                  Icon(Icons.emoji_events_outlined, color: Color(0xFF86E33F), size: 32),
                  SizedBox(width: 12),
                  Text(
                    "Ranking do Mês",
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // LISTA DO RANKING + BOTÃO
              Expanded(
                child: Column(
                  children: [
                    // A Lista Rolável
                    Expanded(
                      child: ListView.separated(
                        itemCount: _controller.rankingList.length,
                        separatorBuilder: (context, index) {
                          // Coloca um divisor com a palavra "Sua Colocação" antes do último item (o usuário atual)
                          if (index == _controller.rankingList.length - 2) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Row(
                                children: [
                                  Expanded(child: Divider(color: Colors.white12)),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: Text("Sua Colocação", style: TextStyle(color: Colors.white54, fontSize: 12)),
                                  ),
                                  Expanded(child: Divider(color: Colors.white12)),
                                ],
                              ),
                            );
                          }
                          return const SizedBox(height: 12);
                        },
                        itemBuilder: (context, index) {
                          return _buildRankingItem(_controller.rankingList[index]);
                        },
                      ),
                    ),
                    
                    // BOTÃO VER COMPLETO / OCULTAR
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: _controller.toggleFullRanking,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                        backgroundColor: const Color(0xFF134D48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _controller.isFullRanking ? "Ocultar Ranking" : "Ver Ranking Completo",
                            style: const TextStyle(color: Color(0xFF86E33F), fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            _controller.isFullRanking ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                            color: const Color(0xFF86E33F),
                            size: 20,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10), // Um espacinho extra pro final da tela
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // WIDGET AUXILIAR QUE DESENHA CADA LINHA DO RANKING
  Widget _buildRankingItem(RankingUser user) {
    // Definindo cores dos troféus (Ouro, Prata, Bronze, e Padrão)
    Color rankColor;
    if (user.rank == 1) {
      rankColor = Colors.amber; 
    } else if (user.rank == 2) {
      rankColor = Colors.grey.shade400; 
    } else if (user.rank == 3) {
      rankColor = Colors.orange.shade300; 
    } else {
      rankColor = Colors.white38; 
    }

    // Se for o usuário atual, o fundo do card fica diferente (como no seu design)
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: user.isCurrentUser ? const Color(0xFF134D48) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: user.isCurrentUser ? Border.all(color: Colors.white12) : null,
      ),
      child: Row(
        children: [
          // Ícone de Posição / Troféu
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: user.rank <= 3 ? rankColor.withOpacity(0.1) : Colors.transparent,
            ),
            child: Center(
              child: user.rank <= 3
                  ? Icon(Icons.emoji_events, color: rankColor, size: 24)
                  : Text("${user.rank}º", style: TextStyle(color: rankColor, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
          const SizedBox(width: 16),
          
          // Avatar (A primeira letra do nome)
          CircleAvatar(
            backgroundColor: user.isCurrentUser ? const Color(0xFF2E7D32) : Colors.white12,
            child: Text(
              user.name.isNotEmpty ? user.name[0].toUpperCase() : "?",
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 16),

          // Nome e Apartamento
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  user.apartment,
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),

          // Pontuação
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${user.points}",
                style: const TextStyle(color: Color(0xFF86E33F), fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const Text(
                "PTS",
                style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}