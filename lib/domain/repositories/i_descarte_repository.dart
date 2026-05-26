import '../../data/models/categoria_material.dart';

abstract interface class IDescarteRepository {
  Future<List<CategoriaMaterial>> getCategorias();
  Future<void> registrarDescarte({
    required String qrCodeHash,
    required int categoriaMaterialId,
    required double pesoKg,
  });
}
