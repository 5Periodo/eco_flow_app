import 'package:flutter/material.dart';
import 'mocker_database.dart';

class RegisterService {
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    String? block,
    required String apartment,
    // File? profileImage, // Descomente quando for enviar a imagem para o backend real
  }) async {
    try {
      // 1. Simulação do tempo de resposta da API
      await Future.delayed(const Duration(seconds: 2));
      
      // 2. Chama o Banco de Dados Falso
      final db = MockDatabase();

      // 3. Atualiza os dados com o que o usuário digitou na tela!
      db.userName = name;
      
      // Monta a string do apartamento bonitinha (com ou sem bloco)
      if (block != null && block.isNotEmpty) {
        db.userApartment = "Bl. $block, Apto $apartment";
      } else {
        db.userApartment = "Apto $apartment";
      }

      // 4. Zera o histórico para a conta nova nascer "limpa"
      db.userPoints = 0;
      db.userCollectionsMonth = 0;
      db.userStreakDays = 1; // Podemos dar 1 dia de ofensiva como presente de boas-vindas!

      debugPrint("MOCK: Novo usuário registrado com sucesso!");
      debugPrint("MOCK: Nome: ${db.userName} | Local: ${db.userApartment}");
      
      return true; 
    } catch (e) {
      debugPrint("MOCK Erro ao registrar: $e");
      return false;
    }
  }
}