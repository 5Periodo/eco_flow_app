import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/datasources/mock_database.dart';

class HomeController extends ChangeNotifier {
  // --- Mapa de pontos base por categoria ---
  static const Map<String, int> _pointsMap = {
    'Plástico': 10,
    'Papel':     8,
    'Vidro':    15,
    'Metal':    12,
    'Óleo':     20,
    'Pilhas':   25,
  };

  static const Map<String, double> _multiplierMap = {
    'Sacola Pequena': 1.0,
    'Sacola Grande':  1.5,
    'Unidade':        0.5,
  };

  // Controle de estado do Modal (0: Código, 1: Foto, 2: Volume, 3: Sucesso)
  int currentStep = 0;

  String selectedCategory  = '';
  IconData? categoryIcon;
  Color? categoryColor;
  final containerCodeController = TextEditingController();
  File? residuePhoto;
  String? selectedVolume;
  bool isLoading = false;

  void startCollection(String category, IconData icon, Color color) {
    selectedCategory = category;
    categoryIcon     = icon;
    categoryColor    = color;
    currentStep      = 0;
    containerCodeController.clear();
    residuePhoto   = null;
    selectedVolume = null;
    notifyListeners();
  }

  void nextStep() {
    if (currentStep < 3) {
      currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      currentStep--;
      notifyListeners();
    }
  }

  Future<void> takePhoto() async {
    final picker = ImagePicker();
    final file   = await picker.pickImage(source: ImageSource.camera);
    if (file != null) {
      residuePhoto = File(file.path);
      nextStep();
    }
  }

  void setVolume(String volume) {
    selectedVolume = volume;
    notifyListeners();
  }

  Future<void> submitCollection() async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    final pontosBase    = _pointsMap[selectedCategory]    ?? 0;
    final multiplicador = _multiplierMap[selectedVolume]  ?? 1.0;
    final pontosGanhos  = (pontosBase * multiplicador).round();

    MockDatabase().addPoints(pontosGanhos);

    debugPrint('Descarte: $selectedVolume de $selectedCategory');
    debugPrint('+$pontosGanhos pts → total: ${MockDatabase().userPoints}');

    isLoading = false;
    nextStep();
  }

  @override
  void dispose() {
    containerCodeController.dispose();
    super.dispose();
  }
}