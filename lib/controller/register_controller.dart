import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
// Certifique-se de que o caminho do import abaixo está correto para o seu projeto
import 'package:rec_coop_app/Models/register_service.dart';

class RegisterController extends ChangeNotifier {
  final RegisterService _registerService;
  
  RegisterController(this._registerService);

  final formKey = GlobalKey<FormState>();
  
  // Controladores para todos os campos do design
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final blockController = TextEditingController();
  final apartmentController = TextEditingController();

  File? profileImage; 
  final ImagePicker _picker = ImagePicker();

  bool isLoading = false;
  bool isObscure = true;
  bool hasProfilePicture = false; 

  void togglePasswordVisibility() {
    isObscure = !isObscure;
    notifyListeners();
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      // Abre a interface do sistema (Câmera ou Galeria)
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 500, // Otimiza o tamanho para não sobrecarregar o backend
        imageQuality: 80, // Comprime levemente a imagem
      );

      if (pickedFile != null) {
        profileImage = File(pickedFile.path);
        hasProfilePicture = true; 
        notifyListeners(); // Avisa a View para mostrar a foto
      }
    } catch (e) {
      debugPrint("Erro ao capturar imagem: $e");
    }
  }

  Future<bool> doRegister() async {
    if (!formKey.currentState!.validate()) return false;

    isLoading = true;
    notifyListeners();

    final success = await _registerService.register(
      name: nameController.text,
      email: emailController.text,
      password: passwordController.text,
      block: blockController.text,
      apartment: apartmentController.text,
      // DESCOMENTE ESTA LINHA QUANDO O BACKEND EM GO ESTIVER PRONTO PARA RECEBER A FOTO
      // profileImage: profileImage 
    );

    isLoading = false;
    notifyListeners();

    return success;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    blockController.dispose();
    apartmentController.dispose();
    super.dispose();
  }
}