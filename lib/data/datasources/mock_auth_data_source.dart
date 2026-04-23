import 'package:flutter/foundation.dart';
import 'mock_database.dart';
import '../../core/errors/app_exceptions.dart';

class MockAuthDataSource {
  final MockDatabase _db;
  MockAuthDataSource(this._db);

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));

    if (email == _db.userEmail && password == _db.userPassword) {
      debugPrint('MOCK: Login com sucesso!');
      return true;
    }

    throw AuthException();
  }
}