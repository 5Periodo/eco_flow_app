// Caminho: lib/features/auth/view/register_page.dart

//import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rec_coop_app/colors/app_colors.dart';
import 'package:rec_coop_app/widgets/custom_text_field.dart';
import 'package:rec_coop_app/widgets/primary_button.dart';
import 'package:rec_coop_app/controller/register_controller.dart';
import 'package:rec_coop_app/Models/register_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final RegisterController _controller;

  @override
  void initState() {
    super.initState();
    _controller = RegisterController(RegisterService());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    final success = await _controller.doRegister();
    if (success && mounted) {
      Navigator.pop(context); 
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Conta criada com sucesso! Faça login.')),
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
                Image.asset(
                  'assets/images/logo_EcoFlow.png',
                  height: 50,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 10),
                const Text("Crie sua conta", style: TextStyle(color: Colors.white60)),
                const SizedBox(height: 30),

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
                            _buildProfilePicture(),
                            const SizedBox(height: 30),
                            
                            _buildInputLabel("Nome completo"),
                            CustomTextField(
                              controller: _controller.nameController,
                              hintText: "Seu nome",
                              keyboardType: TextInputType.name,
                              validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
                            ),
                            
                            const SizedBox(height: 16),
                            
                            _buildInputLabel("Email"),
                            CustomTextField(
                              controller: _controller.emailController,
                              hintText: "seu@email.com",
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'Campo obrigatório';
                                if (!value.contains('@')) return 'E-mail inválido';
                                return null;
                              },
                            ),
                            
                            const SizedBox(height: 16),
                            
                            _buildInputLabel("Senha"),
                            CustomTextField(
                              controller: _controller.passwordController,
                              hintText: "Mínimo 8 caracteres",
                              isObscure: _controller.isObscure,
                              suffixIcon: IconButton(
                                icon: Icon(_controller.isObscure ? Icons.visibility_off : Icons.visibility, color: Colors.white54),
                                onPressed: _controller.togglePasswordVisibility,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'Insira uma senha';
                                if (value.length < 8) return 'Mínimo 8 caracteres';
                                return null;
                              },
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Row para Bloco e Apartamento com os novos CustomTextFields
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildInputLabel("Bloco (opcional)"),
                                      CustomTextField(
                                        controller: _controller.blockController,
                                        hintText: "A, B, C...",
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildInputLabel("Apartamento"),
                                      CustomTextField(
                                        controller: _controller.apartmentController,
                                        hintText: "101, 202...",
                                        keyboardType: TextInputType.number,
                                        validator: (value) => value == null || value.isEmpty ? 'Obrigatório' : null,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 30),
                            
                            // Nosso botão reutilizável super limpo!
                            PrimaryButton(
                              text: "Criar conta",
                              isLoading: _controller.isLoading,
                              onPressed: _handleRegister,
                            ),
                            
                            const SizedBox(height: 20),
                            
                            // Link Voltar para Login
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Já tem uma conta? ", style: TextStyle(color: Colors.white70)),
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: const Text(
                                    "Entrar",
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

  // --- WIDGETS AUXILIARES ESPECÍFICOS DESTA TELA ---

  Widget _buildInputLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 14)),
    );
  }

  Widget _buildProfilePicture() {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              // Mostra um menu inferior para escolher entre Câmera e Galeria
              showModalBottomSheet(
                context: context,
                backgroundColor: AppColors.cardBackground,
                builder: (BuildContext context) {
                  return SafeArea(
                    child: Wrap(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.photo_library, color: Colors.white),
                          title: const Text('Escolher da Galeria', style: TextStyle(color: Colors.white)),
                          onTap: () {
                            _controller.pickImage(ImageSource.gallery);
                            Navigator.of(context).pop();
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.photo_camera, color: Colors.white),
                          title: const Text('Tirar Foto', style: TextStyle(color: Colors.white)),
                          onTap: () {
                            _controller.pickImage(ImageSource.camera);
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF0A2E2A),
                    border: Border.all(color: Colors.white12, width: 2),
                    image: _controller.hasProfilePicture && _controller.profileImage != null
                        ? DecorationImage(
                            image: FileImage(_controller.profileImage!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: !_controller.hasProfilePicture
                      ? const Icon(Icons.camera_alt_outlined, color: Colors.white54, size: 30)
                      : null, 
                ),
                Container(
                  padding: const EdgeInsets.all(6),
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
          const Text("Foto do perfil (opcional)", style: TextStyle(color: Colors.white54, fontSize: 12)),
        ],
      ),
    );
  }
}