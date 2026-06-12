import 'package:flutter/foundation.dart';
import 'mock_database.dart';

class MockRegisterDataSource {
  final MockDatabase _db;
  MockRegisterDataSource(this._db);

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    String? block,
    required String apartment,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    final apartmentStr = (block != null && block.isNotEmpty)
        ? 'Bl. $block, Apto $apartment'
        : 'Apto $apartment';

    _db.resetForNewUser(name: name, apartment: apartmentStr);

    debugPrint('MOCK: Registrado → $name | $apartmentStr');
    return true;
  }
}