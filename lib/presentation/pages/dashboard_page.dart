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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation:       0,
        title: Image.asset('assets/images/logo_EcoFlow.png', height: 30),
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
}