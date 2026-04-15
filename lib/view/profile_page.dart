import 'package:flutter/material.dart';
import 'package:rec_coop_app/controller/profile_controller.dart';
import 'package:rec_coop_app/Models/profile_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Injetando a dependência de forma limpa
  late final ProfileController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ProfileController(ProfileService());
    // Manda buscar os dados assim que a tela abre!
    _controller.loadProfile();
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
        if (_controller.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF86E33F)),
          );
        }

        if (_controller.profile == null) {
          return const Center(
            child: Text("Erro ao carregar dados do perfil.", style: TextStyle(color: Colors.white)),
          );
        }

        final user = _controller.profile!;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildAvatar(),
              const SizedBox(height: 16),
              
              // NOME DINÂMICO
              Text(
                user.name,
                style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              
              // APARTAMENTO DINÂMICO
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(color: const Color(0xFF134D48), borderRadius: BorderRadius.circular(20)),
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
                icon: const Icon(Icons.edit, color: Colors.white, size: 18),
                label: const Text("Editar Perfil", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF134D48),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // PONTOS DINÂMICOS
              _buildBalanceCard(user.points),
              
              const SizedBox(height: 16),
              
              Row(
                children: [
                  // ESTATÍSTICAS DINÂMICAS
                  Expanded(child: _buildStatCard(Icons.calendar_today, Colors.blue, "${user.collectionsMonth}", "COLETAS NO MÊS")),
                  const SizedBox(width: 16),
                  Expanded(child: _buildStatCard(Icons.local_fire_department, Colors.orange, "${user.streakDays} dias", "OFENSIVA ATUAL")),
                ],
              ),
            ],
          ),
        );
      }
    );
  }

  Widget _buildAvatar() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF134D48),
            border: Border.all(color: const Color(0xFF1A635D), width: 3),
          ),
          child: const Icon(Icons.person_outline, color: Colors.white54, size: 50),
        ),
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFF86E33F),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF0D3B36), width: 3),
          ),
          child: const Icon(Icons.camera_alt, color: Colors.black, size: 16),
        ),
      ],
    );
  }

  Widget _buildBalanceCard(int points) {
    // Lógica simples de Níveis baseada nos pontos reais!
    String nivel = "Iniciante";
    int proximoNivel = 100;
    
    if (points >= 100) { nivel = "Engajado"; proximoNivel = 300; }
    if (points >= 300) { nivel = "Eco Master"; proximoNivel = 1000; }
    
    int faltam = proximoNivel - points;
    double progresso = points / proximoNivel;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF134D48),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Saldo Atual", style: TextStyle(color: Colors.white54, fontSize: 16)),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text("$points", style: const TextStyle(color: Color(0xFF86E33F), fontSize: 48, fontWeight: FontWeight.bold, height: 1)),
              const SizedBox(width: 4),
              const Text("pts", style: TextStyle(color: Colors.white54, fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 30),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFF0A2E2A), borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.shield_outlined, color: Color(0xFF86E33F), size: 18),
                        const SizedBox(width: 6),
                        Text(nivel, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Text("Faltam $faltam pts", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progresso > 1.0 ? 1.0 : progresso, // Barra baseada no nível atual!
                    backgroundColor: const Color(0xFF134D48),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(IconData icon, Color iconColor, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(height: 16),
          Text(value, style: const TextStyle(color: Color(0xFF0D3B36), fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        ],
      ),
    );
  }
}