import 'package:flutter/material.dart';
import '../Models/user_profile.dart';
import '../Models/profile_service.dart';

class ProfileController extends ChangeNotifier {
  final ProfileService _service;

  ProfileController(this._service);

  UserProfile? profile; 
  bool isLoading = true;

  Future<void> loadProfile() async {
    isLoading = true;
    notifyListeners();

    try {
      profile = await _service.getUserData();
    } catch (e) {
      debugPrint("Erro ao carregar perfil: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}