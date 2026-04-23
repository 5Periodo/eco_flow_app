import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../colors/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../presentation/controllers/profile_controller.dart';
import '../../presentation/pages/home_page.dart';
import '../../presentation/pages/ranking_page.dart';
import '../../presentation/pages/coupon_page.dart';
import '../../presentation/pages/profile_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  static const List<Widget> _screens = [
    HomePage(),
    RankingPage(),
    CouponPage(),
    ProfilePage(),
  ];

  void _onTabTapped(int index) => setState(() => _currentIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      endDrawer: _buildDrawer(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation:       0,
        title: Image.asset('assets/images/logo_EcoFlow.png', height: 30),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none, color: Colors.white)),
          Builder(builder: (ctx) => IconButton(
            onPressed: () => Scaffold.of(ctx).openEndDrawer(),
            icon: const Icon(Icons.menu, color: Colors.white),
          )),
        ],
      ),
      body:              _screens[_currentIndex],
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex:         _currentIndex,
      onTap:                _onTabTapped,
      backgroundColor:      const Color(0xFF0A2E2A),
      type:                 BottomNavigationBarType.fixed,
      selectedItemColor:    AppColors.primaryButton,
      unselectedItemColor:  Colors.white54,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home),                    label: 'Início'),
        BottomNavigationBarItem(icon: Icon(Icons.emoji_events_outlined),   label: 'Ranking'),
        BottomNavigationBarItem(icon: Icon(Icons.card_giftcard),           label: 'Cupons'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline),          label: 'Perfil'),
      ],
    );
  }

  Widget _buildDrawer(BuildContext context) {
    // Lê nome e apartamento do ProfileController — sem hardcode
    final profile = context.watch<ProfileController>().profile;
    final name      = profile?.name      ?? '';
    final apartment = profile?.apartment ?? '';
    final initial   = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Drawer(
      backgroundColor: AppColors.cardBackground,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFF2E7D32),
                child: Text(initial, style: const TextStyle(color: Colors.white)),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Text(apartment, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 40),
          ListTile(
            leading: const Icon(Icons.person_outline, color: Colors.white54),
            title:   const Text('Meu Perfil', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              _onTabTapped(3);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title:   const Text('Sair da conta', style: TextStyle(color: Colors.redAccent)),
            onTap:   () => Navigator.pushReplacementNamed(context, AppRoutes.login),
          ),
        ],
      ),
    );
  }
}