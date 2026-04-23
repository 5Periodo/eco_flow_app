import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../colors/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../presentation/controllers/login_controller.dart';
import '../../presentation/widgets/custom_text_field.dart';
import '../../presentation/widgets/primary_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  void _handleLogin(BuildContext context) async {
    final controller = context.read<LoginController>();
    final success    = await controller.doLogin();
    if (success && context.mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
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
                Image.asset('assets/images/logo_EcoFlow.png', height: 60, fit: BoxFit.contain),
                const SizedBox(height: 10),
                const Text('Entre na sua conta', style: TextStyle(color: Colors.white60)),
                const SizedBox(height: 40),

                Consumer<LoginController>(
                  builder: (context, controller, _) {
                    return Container(
                      padding:    const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color:        AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Form(
                        key: controller.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Email', style: TextStyle(color: Colors.white)),
                            const SizedBox(height: 8),
                            CustomTextField(
                              controller:  controller.emailController,
                              hintText:    'seu@email.com',
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) {
                                if (v == null || v.isEmpty) return 'Insira seu e-mail';
                                if (!v.contains('@')) return 'E-mail inválido';
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            const Text('Senha', style: TextStyle(color: Colors.white)),
                            const SizedBox(height: 8),
                            CustomTextField(
                              controller: controller.passwordController,
                              hintText:   '........',
                              isObscure:  controller.isObscure,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.isObscure ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.white54,
                                ),
                                onPressed: controller.togglePasswordVisibility,
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty) return 'Insira sua senha';
                                if (v.length < 6) return 'Mínimo 6 caracteres';
                                return null;
                              },
                            ),

                            // Mensagem de erro de autenticação
                            if (controller.errorMessage != null) ...[
                              const SizedBox(height: 12),
                              Text(
                                controller.errorMessage!,
                                style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                              ),
                            ],

                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  padding:         const EdgeInsets.symmetric(vertical: 8),
                                  minimumSize:     Size.zero,
                                  tapTargetSize:   MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text('Esqueceu a senha?',
                                    style: TextStyle(color: AppColors.primaryButton, fontSize: 13)),
                              ),
                            ),
                            const SizedBox(height: 20),

                            PrimaryButton(
                              text:      'Entrar',
                              isLoading: controller.isLoading,
                              onPressed: () => _handleLogin(context),
                            ),
                            const SizedBox(height: 20),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Não tem uma conta? ', style: TextStyle(color: Colors.white70)),
                                GestureDetector(
                                  onTap: () => Navigator.pushNamed(context, AppRoutes.register),
                                  child: const Text('Cadastre-se',
                                      style: TextStyle(color: AppColors.primaryButton, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}