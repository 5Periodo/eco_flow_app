
import 'package:flutter/material.dart';
import 'package:rec_coop_app/view/home_page.dart';
import 'package:rec_coop_app/view/ranking_page.dart';
//import 'package:rec_coop_app/features/coupons/coupons_page.dart';
import 'package:rec_coop_app/view/profile_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const HomePage(), 
      const RankingPage(),
      const Center(child: Text("Cupons", style: TextStyle(color: Colors.white))),
      const ProfilePage(), 
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0D3B36),
      endDrawer: _buildDrawer(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Image.asset('assets/images/logo_EcoFlow.png', height: 30),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none, color: Colors.white)),
          Builder(builder: (context) {
            return IconButton(
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              icon: const Icon(Icons.menu, color: Colors.white),
            );
          }),
        ],
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _onTabTapped,
      backgroundColor: const Color(0xFF0A2E2A),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF86E33F),
      unselectedItemColor: Colors.white54,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Início"),
        BottomNavigationBarItem(icon: Icon(Icons.emoji_events_outlined), label: "Ranking"),
        BottomNavigationBarItem(icon: Icon(Icons.card_giftcard), label: "Cupons"),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Perfil"),
      ],
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF134D48),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        children: [
          const Row(
            children: [
              CircleAvatar(backgroundColor: Color(0xFF2E7D32), child: Text("K")),
              SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("kaiky", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Text("Apto 102", style: TextStyle(color: Colors.white54, fontSize: 12)),
                ],
              )
            ],
          ),
          const SizedBox(height: 40),
          ListTile(
            leading: const Icon(Icons.person_outline, color: Colors.white54),
            title: const Text("Meu Perfil", style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              _onTabTapped(3);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text("Sair da conta", style: TextStyle(color: Colors.redAccent)),
            onTap: () => Navigator.pushReplacementNamed(context, '/login'),
          ),
        ],
      ),
    );
  }
}