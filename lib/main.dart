import 'package:flutter/material.dart';
import 'package:rec_coop_app/view/login_page.dart';
import 'package:rec_coop_app/view/register_page.dart';
import 'package:rec_coop_app/view/dashboard_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eco Flow',
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const DashboardPage(),
      },
    );
  }
}