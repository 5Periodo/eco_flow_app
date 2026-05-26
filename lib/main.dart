import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

// Core
import 'core/network/dio_client.dart';
import 'core/routes/app_routes.dart';
import 'core/storage/secure_storage_service.dart';
import 'colors/app_colors.dart';

// DataSources
import 'data/datasources/remote/descarte_remote_data_source.dart';
import 'data/datasources/remote/profile_remote_data_source.dart';
import 'data/datasources/remote/ranking_remote_data_source.dart';
import 'data/datasources/remote/recompensa_remote_data_source.dart';

// Repositories
import 'data/repositories/coupon_repository.dart';
import 'data/repositories/descarte_repository.dart';
import 'data/repositories/profile_repository.dart';
import 'data/repositories/ranking_repository.dart';

// Controllers
import 'presentation/controllers/coupon_controller.dart';
import 'presentation/controllers/home_controller.dart';
import 'presentation/controllers/profile_controller.dart';
import 'presentation/controllers/ranking_controller.dart';

// Pages
import 'presentation/pages/login_page.dart';
import 'presentation/pages/dashboard_page.dart';
import 'presentation/pages/qr_scanner_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = SecureStorageService(const FlutterSecureStorage());
    final dio     = DioClient.create(storage);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => HomeController(
            DescarteRepository(DescarteRemoteDataSource(dio)),
          )..loadCategories(),
        ),
        ChangeNotifierProvider(
          create: (_) => CouponController(
            CouponRepository(RecompensaRemoteDataSource(dio)),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileController(
            ProfileRepository(ProfileRemoteDataSource(dio)),
          )..loadProfile(),
        ),
        ChangeNotifierProvider(
          create: (_) => RankingController(
            RankingRepository(RankingRemoteDataSource(dio)),
          )..loadRanking(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title:        'Eco Flow',
        theme: ThemeData(scaffoldBackgroundColor: AppColors.background),
        initialRoute: AppRoutes.login,
        routes: {
          AppRoutes.login:      (_) => const LoginPage(),
          AppRoutes.home:       (_) => const DashboardPage(),
          AppRoutes.qrScanner:  (_) => const QrScannerPage(),
        },
      ),
    );
  }
}
