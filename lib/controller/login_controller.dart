
import 'package:flutter/material.dart';
import 'package:rec_coop_app/Models/login_service.dart';

class LoginController extends ChangeNotifier {
  final MockAuthService _authService;

  LoginController(this._authService);

  // Controladores de texto e formulário isolados da View
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Estados
  bool isLoading = false;
  bool isObscure = true;

  void togglePasswordVisibility() {
    isObscure = !isObscure;
    notifyListeners(); // Avisa a View para se redesenhar
  }

  Future<bool> doLogin() async {
    // Se o formulário for inválido, interrompe a ação
    if (!formKey.currentState!.validate()) return false;

    isLoading = true;
    notifyListeners();

    // Chama o Service passando os dados
    final success = await _authService.login(
      emailController.text,
      passwordController.text,
    );

    isLoading = false;
    notifyListeners();

    return success;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}