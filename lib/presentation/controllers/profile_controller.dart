import 'package:flutter/material.dart';
import '../../domain/repositories/i_profile_repository.dart';
import '../../data/models/user_profile.dart';

class ProfileController extends ChangeNotifier {
  final IProfileRepository _repository;
  ProfileController(this._repository);

  UserProfile? profile;
  bool isLoading   = false;
  bool isUpdating  = false;
  String? errorMessage;
  String? successMessage;

  Future<void> loadProfile() async {
    isLoading    = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    try {
      profile = await _repository.getProfile();
    } on Exception {
      errorMessage = 'Erro ao carregar perfil.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile(String name, String? password) async {
    isUpdating   = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    try {
      profile = await _repository.updateProfile(name, password);
      successMessage = 'Perfil atualizado com sucesso!';
      notifyListeners();
      return true;
    } on Exception {
      errorMessage = 'Erro ao atualizar perfil.';
      notifyListeners();
      return false;
    } finally {
      isUpdating = false;
      notifyListeners();
    }
  }
}