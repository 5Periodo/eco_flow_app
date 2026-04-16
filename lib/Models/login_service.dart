import 'package:flutter/material.dart';

// 1. O CONTRATO (Interface)
// Todo serviço de autenticação DEVE ter uma função de login.
abstract class IAuthService {
  Future<bool> login(String email, String password);
}

// 2. O SERVIÇO FALSO (Mock) para você usar AGORA
class MockAuthService implements IAuthService {
  @override
  Future<bool> login(String email, String password) async {
    // Simula o tempo de carregamento da internet (2 segundos)
    await Future.delayed(const Duration(seconds: 2));
    
    // Lógica falsa: Se digitar esse email e senha, o login dá certo. 
    // Qualquer outra coisa vai dar "Credenciais inválidas" e a bolinha de loading para.
    if (email == 'teste@gmail.com' && password == '12345678') {
      debugPrint("MOCK: Login com sucesso!");
      return true; 
    } else {
      debugPrint("MOCK: Credenciais inválidas!");
      return false; 
    }
  }
}

// 3. O SERVIÇO REAL para usar DEPOIS (quando a API Go estiver pronta)
class RealAuthService implements IAuthService {
  @override
  Future<bool> login(String email, String password) async {
    // Aqui vai entrar o código real de backend (http.post) no futuro.
    throw UnimplementedError('Backend em Go ainda não está pronto!');
  }
}