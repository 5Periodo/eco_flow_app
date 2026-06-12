import 'package:flutter/material.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../../core/errors/app_exceptions.dart';

class LoginController extends ChangeNotifier {
  final IAuthRepository _repository;
  LoginController(this._repository);

  final formKey           = GlobalKey<FormState>();
  final emailController    = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading   = false;
  bool isObscure   = true;
  String? errorMessage;

  void togglePasswordVisibility() {
    isObscure = !isObscure;
    notifyListeners();
  }

  Future<bool> doLogin() async {
    if (!formKey.currentState!.validate()) return false;

    isLoading    = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _repository.login(
        emailController.text.trim(),
        passwordController.text,
      );
      return true;
    } on AuthException catch (e) {
      errorMessage = e.message;
      return false;
    } on NetworkException catch (e) {
      errorMessage = e.message;
      return false;
    } on Exception {
      errorMessage = 'Erro inesperado. Tente novamente.';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
