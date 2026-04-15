// Caminho: lib/features/home/controller/home_controller.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Models/mocker_database.dart';

class HomeController extends ChangeNotifier {
  // Controle de estado do Modal (0: Código, 1: Foto, 2: Volume, 3: Sucesso)
  int currentStep = 0;
  
  // Dados coletados
  String selectedCategory = '';
  IconData? categoryIcon;
  Color? categoryColor;
  final containerCodeController = TextEditingController();
  File? residuePhoto;
  String? selectedVolume;
  
  bool isLoading = false;

  void startCollection(String category, IconData icon, Color color) {
    selectedCategory = category;
    categoryIcon = icon;
    categoryColor = color;
    currentStep = 0;
    containerCodeController.clear();
    residuePhoto = null;
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
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      residuePhoto = File(pickedFile.path);
      nextStep(); // Avança automaticamente após tirar a foto
    }
  }

  void setVolume(String volume) {
    selectedVolume = volume;
    notifyListeners();
  }

  Future<void> submitCollection() async {
    isLoading = true;
    notifyListeners();

    // Simula o tempo de envio para a API (2 segundos)
    await Future.delayed(const Duration(seconds: 2));

    // 1. Lógica dos Pontos Base
    int pontosBase = 0;
    if (selectedCategory == 'Plástico'){
       pontosBase = 10;
      }
    else if (selectedCategory == 'Papel'){
       pontosBase = 8;
      }
    else if (selectedCategory == 'Vidro'){
       pontosBase = 15;
      }
    else if (selectedCategory == 'Metal'){
       pontosBase = 12;
      }
    else if (selectedCategory == 'Óleo'){
       pontosBase = 20;
      }
    else if (selectedCategory == 'Pilhas'){
       pontosBase = 25;
      }

    // 2. Lógica do Multiplicador de Volume
    double multiplicador = 1.0; // Padrão para "Sacola Pequena"
    if (selectedVolume == 'Sacola Grande'){
      multiplicador = 1.5;
    }
    else if (selectedVolume == 'Unidade') {
      multiplicador = 0.5;
    }

    // 3. Calcula o total final (arredondando para não ter número quebrado)
    int pontosGanhos = (pontosBase * multiplicador).round();

    // 4. SALVA NO BANCO DE DADOS FALSO!
    // Pega o MockDatabase e soma os pontos e a coleta na conta global
    MockDatabase().addPoints(pontosGanhos);

    // Logs para você ver o funcionamento no terminal/debug console
    debugPrint("Descarte de $selectedVolume de $selectedCategory!");
    debugPrint("O usuário acaba de ganhar +$pontosGanhos pontos!");
    debugPrint("Total de pontos do usuário agora é: ${MockDatabase().userPoints}");

    isLoading = false;
    nextStep(); // Vai para a tela final de "Mandou bem!"
  }

  @override
  void dispose() {
    containerCodeController.dispose();
    super.dispose();
  }
}