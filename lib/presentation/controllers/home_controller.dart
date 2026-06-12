import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/errors/app_exceptions.dart';
import '../../data/models/categoria_material.dart';
import '../../domain/repositories/i_descarte_repository.dart';

class HomeController extends ChangeNotifier {
  final IDescarteRepository _repository;
  HomeController(this._repository);

  // Categorias carregadas da API
  List<CategoriaMaterial> categories       = [];
  bool                    isLoadingCats    = false;
  String?                 categoriesError;

  // Estado do fluxo de descarte
  CategoriaMaterial? selectedCategory;
  String?            qrCodeHash;
  final              pesoKgController = TextEditingController();
  bool               startedFromCategory = false;

  // 0 = QR scan (quando vem de categoria) | 0 = picker (quando vem do banner)
  // 1 = peso  |  2 = sucesso
  int     currentStep  = 0;
  bool    isLoading    = false;
  String? errorMessage;
  String? capturedPhotoBase64;

  Future<void> loadCategories() async {
    isLoadingCats   = true;
    categoriesError = null;
    notifyListeners();

    try {
      categories = await _repository.getCategorias();
    } on AuthException catch (e) {
      categoriesError = e.message;
    } on NetworkException catch (e) {
      categoriesError = e.message;
    } on Exception {
      categoriesError = 'Não foi possível carregar as categorias.';
    } finally {
      isLoadingCats = false;
      notifyListeners();
    }
  }

  // Entrada via card de categoria → passo 0 = escanear QR
  void startFromCategory(CategoriaMaterial category) {
    selectedCategory = category;
    qrCodeHash       = null;
    startedFromCategory = true;
    currentStep      = 0;
    errorMessage     = null;
    capturedPhotoBase64 = null;
    pesoKgController.clear();
    notifyListeners();
  }

  // Entrada via banner QR (QR já escaneado antes de abrir o modal)
  // → passo 0 = escolher categoria
  void startFromQrScan(String hash) {
    selectedCategory = null;
    qrCodeHash       = hash;
    startedFromCategory = false;
    currentStep      = 0;
    errorMessage     = null;
    capturedPhotoBase64 = null;
    pesoKgController.clear();
    notifyListeners();
  }

  // Chamado após o scanner retornar o hash (fluxo via card de categoria)
  void setQrHash(String hash) {
    qrCodeHash  = hash;
    currentStep = 1;
    notifyListeners();
  }

  // Chamado quando o morador escolhe a categoria (fluxo via banner QR)
  void selectCategory(CategoriaMaterial category) {
    selectedCategory = category;
    currentStep      = 1;
    notifyListeners();
  }

  String get flowTitle {
    if (currentStep == 2) return 'Descarte concluído';
    if (currentStep == 1) return 'Confirme o peso';
    return startedFromCategory ? 'Escaneie o contentor' : 'Escolha o material';
  }

  String get flowSubtitle {
    if (currentStep == 2) return 'Seu descarte foi registrado com sucesso.';
    if (currentStep == 1) {
      return startedFromCategory
          ? 'Agora informe o peso para registrar o descarte.'
          : 'Agora escaneie o QR do contentor para continuar.';
    }
    return startedFromCategory
        ? 'Primeiro, aproxime a câmera do QR Code do contentor.'
        : 'Selecione o resíduo antes de escanear o contentor.';
  }

  double get progressValue {
    return switch (currentStep) {
      0 => 0.33,
      1 => 0.66,
      _ => 1.0,
    };
  }

  String get progressLabel {
    return switch (currentStep) {
      0 => 'Etapa 1 de 3',
      1 => 'Etapa 2 de 3',
      _ => 'Etapa 3 de 3',
    };
  }

  void resetFlow() {
    selectedCategory = null;
    qrCodeHash = null;
    startedFromCategory = false;
    currentStep = 0;
    isLoading = false;
    errorMessage = null;
    capturedPhotoBase64 = null;
    pesoKgController.clear();
    notifyListeners();
  }

  Future<void> capturePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50, // Comprime a imagem para 50%
      maxWidth: 800,
    );

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      final base64String = base64Encode(bytes);
      capturedPhotoBase64 = 'data:image/jpeg;base64,$base64String';
      notifyListeners();
    }
  }

  Future<void> submitDescarte() async {
    if (capturedPhotoBase64 == null) {
      errorMessage = 'Por favor, tire uma foto do descarte.';
      notifyListeners();
      return;
    }

    final peso = double.tryParse(pesoKgController.text.replaceAll(',', '.'));
    if (peso == null || peso <= 0) {
      errorMessage = 'Insira um peso válido em kg.';
      notifyListeners();
      return;
    }

    isLoading    = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _repository.registrarDescarte(
        qrCodeHash:          qrCodeHash!,
        categoriaMaterialId: selectedCategory!.id,
        pesoKg:              peso,
        fotoUrls:            capturedPhotoBase64 != null ? [capturedPhotoBase64!] : null,
      );
      currentStep = 2;
    } on AuthException catch (e) {
      errorMessage = e.message;
    } on NetworkException catch (e) {
      errorMessage = e.message;
    } on Exception {
      errorMessage = 'Erro ao registrar descarte. Tente novamente.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    pesoKgController.dispose();
    super.dispose();
  }
}
