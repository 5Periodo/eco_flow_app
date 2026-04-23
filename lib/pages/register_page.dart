import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../colors/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../presentation/controllers/register_controller.dart';
import '../../presentation/widgets/custom_text_field.dart';
import '../../presentation/widgets/primary_button.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  void _handleRegister(BuildContext context) async {
    final controller = context.read<RegisterController>();
    final success    = await controller.doRegister();
    if (success && context.mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Conta criada! Faça login.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              children: [
                Image.asset('assets/images/logo_EcoFlow.png', height: 50, fit: BoxFit.contain),
                const SizedBox(height: 10),
                const Text('Crie sua conta', style: TextStyle(color: Colors.white60)),
                const SizedBox(height: 30),

                Consumer<RegisterController>(
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
                            _ProfilePicture(controller: controller),
                            const SizedBox(height: 30),

                            _label('Nome completo'),
                            CustomTextField(
                              controller: controller.nameController,
                              hintText:   'Seu nome',
                              keyboardType: TextInputType.name,
                              validator: (v) => v == null || v.isEmpty ? 'Campo obrigatório' : null,
                            ),
                            const SizedBox(height: 16),

                            _label('Email'),
                            CustomTextField(
                              controller:  controller.emailController,
                              hintText:    'seu@email.com',
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) {
                                if (v == null || v.isEmpty) return 'Campo obrigatório';
                                if (!v.contains('@')) return 'E-mail inválido';
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            _label('Senha'),
                            CustomTextField(
                              controller: controller.passwordController,
                              hintText:   'Mínimo 8 caracteres',
                              isObscure:  controller.isObscure,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.isObscure ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.white54,
                                ),
                                onPressed: controller.togglePasswordVisibility,
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty) return 'Insira uma senha';
                                if (v.length < 8) return 'Mínimo 8 caracteres';
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _label('Bloco (opcional)'),
                                      CustomTextField(
                                        controller: controller.blockController,
                                        hintText:   'A, B, C...',
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _label('Apartamento'),
                                      CustomTextField(
                                        controller:  controller.apartmentController,
                                        hintText:    '101, 202...',
                                        keyboardType: TextInputType.number,
                                        validator: (v) => v == null || v.isEmpty ? 'Obrigatório' : null,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            if (controller.errorMessage != null) ...[
                              const SizedBox(height: 12),
                              Text(controller.errorMessage!,
                                  style: const TextStyle(color: Colors.redAccent, fontSize: 13)),
                            ],

                            const SizedBox(height: 30),
                            PrimaryButton(
                              text:      'Criar conta',
                              isLoading: controller.isLoading,
                              onPressed: () => _handleRegister(context),
                            ),
                            const SizedBox(height: 20),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Já tem uma conta? ', style: TextStyle(color: Colors.white70)),
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: const Text('Entrar',
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

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 14)),
      );
}

class _ProfilePicture extends StatelessWidget {
  final RegisterController controller;
  const _ProfilePicture({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: () => showModalBottomSheet(
              context:         context,
              backgroundColor: AppColors.cardBackground,
              builder: (_) => SafeArea(
                child: Wrap(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.photo_library, color: Colors.white),
                      title:   const Text('Escolher da Galeria', style: TextStyle(color: Colors.white)),
                      onTap: () {
                        controller.pickImage(ImageSource.gallery);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.photo_camera, color: Colors.white),
                      title:   const Text('Tirar Foto', style: TextStyle(color: Colors.white)),
                      onTap: () {
                        controller.pickImage(ImageSource.camera);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width:  90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape:  BoxShape.circle,
                    color:  const Color(0xFF0A2E2A),
                    border: Border.all(color: Colors.white12, width: 2),
                    image: controller.hasProfilePicture && controller.profileImage != null
                        ? DecorationImage(
                            image: FileImage(controller.profileImage!),
                            fit:   BoxFit.cover,
                          )
                        : null,
                  ),
                  child: !controller.hasProfilePicture
                      ? const Icon(Icons.camera_alt_outlined, color: Colors.white54, size: 30)
                      : null,
                ),
                Container(
                  padding:    const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryButton,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.black, size: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Text('Foto do perfil (opcional)', style: TextStyle(color: Colors.white54, fontSize: 12)),
        ],
      ),
    );
  }
}