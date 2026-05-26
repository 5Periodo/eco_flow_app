import '../../domain/repositories/i_descarte_repository.dart';
import '../../data/datasources/remote/descarte_remote_data_source.dart';
import '../../data/models/categoria_material.dart';
import '../../data/models/user_profile.dart'; // For RecentDescarte

class DescarteRepository implements IDescarteRepository {
  final DescarteRemoteDataSource _remote;
  DescarteRepository(this._remote);

  @override
  Future<List<CategoriaMaterial>> getCategorias() => _remote.fetchCategorias();

  @override
  Future<List<RecentDescarte>> getHistorico() => _remote.fetchHistorico();

  @override
  Future<void> registrarDescarte({
    required String qrCodeHash,
    required int categoriaMaterialId,
    required double pesoKg,
  }) =>
      _remote.registrarDescarte(
        qrCodeHash:          qrCodeHash,
        categoriaMaterialId: categoriaMaterialId,
        pesoKg:              pesoKg,
      );
}
