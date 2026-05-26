import '../../data/models/categoria_material.dart';
import '../../data/models/user_profile.dart'; // For RecentDescarte

abstract interface class IDescarteRepository {
  Future<List<CategoriaMaterial>> getCategorias();
  Future<List<RecentDescarte>> getHistorico();
  Future<void> registrarDescarte({
    required String qrCodeHash,
    required int categoriaMaterialId,
    required double pesoKg,
  });
}
