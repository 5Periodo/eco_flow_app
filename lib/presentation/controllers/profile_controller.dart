import 'package:flutter/material.dart';
import '../../domain/repositories/i_profile_repository.dart';
import '../../data/models/user_profile.dart';

class ProfileController extends ChangeNotifier {
  final IProfileRepository _repository;
  ProfileController(this._repository);

  UserProfile? profile;
  bool isLoading   = false;
  String? errorMessage;

  Future<void> loadProfile() async {
    isLoading    = true;
    errorMessage = null;
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
}