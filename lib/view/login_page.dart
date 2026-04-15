// Caminho: lib/features/auth/view/login_page.dart

import 'package:flutter/material.dart';
import 'package:rec_coop_app/colors/app_colors.dart';
import 'package:rec_coop_app/controller/login_controller.dart';
import 'package:rec_coop_app/Models/login_service.dart';
import 'package:rec_coop_app/widgets/custom_text_field.dart';
import 'package:rec_coop_app/widgets/primary_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final LoginController _controller;

  @override
  void initState() {
    super.initState();
    _controller = LoginController(MockAuthService());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final success = await _controller.doLogin();
    if (success && mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/logo_EcoFlow.png',
                  height: 60,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 10),
                const Text("Entre na sua conta", style: TextStyle(color: Colors.white60)),
                const SizedBox(height: 40),

                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Form(
                    key: _controller.formKey,
                    child: ListenableBuilder(
                      listenable: _controller,
                      builder: (context, _) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Email", style: TextStyle(color: Colors.white)),
                            const SizedBox(height: 8),

                            // 1. AQUI ENTRA O NOSSO WIDGET DE TEXTO
                            CustomTextField(
                              controller: _controller.emailController,
                              hintText: "seu@email.com",
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'Por favor, insira seu e-mail';
                                if (!value.contains('@')) return 'Insira um e-mail válido';
                                return null;
                              },
                            ),
                            
                            const SizedBox(height: 20),
                            
                            const Text("Senha", style: TextStyle(color: Colors.white)),
                            const SizedBox(height: 8),

                            // 2. WIDGET DE TEXTO REAPROVEITADO PARA A SENHA
                            CustomTextField(
                              controller: _controller.passwordController,
                              hintText: "........",
                              isObscure: _controller.isObscure,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _controller.isObscure ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.white54,
                                ),
                                onPressed: _controller.togglePasswordVisibility,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'Por favor, insira sua senha';
                                if (value.length < 6) return 'Mínimo de 6 caracteres';
                                return null;
                              },
                            ),
                            
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  "Esqueceu a senha?",
                                  style: TextStyle(color: AppColors.primaryButton, fontSize: 13),
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 20),
                            
                            // 3. AQUI ENTRA O NOSSO BOTÃO REUTILIZÁVEL!
                            PrimaryButton(
                              text: "Entrar",
                              isLoading: _controller.isLoading,
                              onPressed: _handleLogin,
                            ),
                            
                            const SizedBox(height: 20),
                            
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Não tem uma conta? ", style: TextStyle(color: Colors.white70)),
                                GestureDetector(
                                  onTap: () => Navigator.pushNamed(context, '/register'),
                                  child: const Text(
                                    "Cadastre-se",
                                    style: TextStyle(color: AppColors.primaryButton, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}