import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Core
import 'core/routes/app_routes.dart';
import 'colors/app_colors.dart';

// DataSources
import 'data/datasources/mock_database.dart';
import 'data/datasources/mock_coupon_data_source.dart';
import 'data/datasources/mock_profile_data_source.dart';
import 'data/datasources/mock_ranking_data_source.dart';

// Repositories
import 'data/repositories/coupon_repository.dart';
import 'data/repositories/profile_repository.dart';
import 'data/repositories/ranking_repository.dart';

// Controllers
import 'presentation/controllers/coupon_controller.dart';
import 'presentation/controllers/profile_controller.dart';
import 'presentation/controllers/ranking_controller.dart';

// Pages
import 'presentation/pages/login_page.dart';
import 'presentation/pages/register_page.dart';
import 'presentation/pages/dashboard_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Única instância do banco falso — compartilhada por todos os datasources
    final db = MockDatabase();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CouponController(
            CouponRepository(MockCouponDataSource(db)),
          )..loadCoupons(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileController(
            ProfileRepository(MockProfileDataSource(db)),
          )..loadProfile(),
        ),
        ChangeNotifierProvider(
          create: (_) => RankingController(
            RankingRepository(MockRankingDataSource(db)),
          )..loadRanking(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title:        'Eco Flow',
        theme: ThemeData(scaffoldBackgroundColor: AppColors.background),
        initialRoute: AppRoutes.login,
        routes: {
          AppRoutes.login:    (_) => const LoginPage(),
          AppRoutes.register: (_) => const RegisterPage(),
          AppRoutes.home:     (_) => const DashboardPage(),
        },
      ),
    );
  }
}