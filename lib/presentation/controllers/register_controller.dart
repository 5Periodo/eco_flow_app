import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/repositories/i_register_repository.dart';

class RegisterController extends ChangeNotifier {
  final IRegisterRepository _repository;
  RegisterController(this._repository);

  final formKey            = GlobalKey<FormState>();
  final nameController       = TextEditingController();
  final emailController      = TextEditingController();
  final passwordController   = TextEditingController();
  final blockController      = TextEditingController();
  final apartmentController  = TextEditingController();

  File? profileImage;
  final _picker = ImagePicker();

  bool isLoading        = false;
  bool isObscure        = true;
  bool hasProfilePicture = false;
  String? errorMessage;

  void togglePasswordVisibility() {
    isObscure = !isObscure;
    notifyListeners();
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final file = await _picker.pickImage(
        source:       source,
        maxWidth:     500,
        imageQuality: 80,
      );
      if (file != null) {
        profileImage      = File(file.path);
        hasProfilePicture = true;
        notifyListeners();
      }
    } on Exception catch (e) {
      debugPrint('Erro ao capturar imagem: $e');
    }
  }

  Future<bool> doRegister() async {
    if (!formKey.currentState!.validate()) return false;

    isLoading    = true;
    errorMessage = null;
    notifyListeners();

    try {
      return await _repository.register(
        name:      nameController.text.trim(),
        email:     emailController.text.trim(),
        password:  passwordController.text,
        block:     blockController.text.trim(),
        apartment: apartmentController.text.trim(),
      );
    } on Exception {
      errorMessage = 'Erro ao criar conta. Tente novamente.';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
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