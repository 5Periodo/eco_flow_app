abstract interface class IRegisterRepository {
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    String? block,
    required String apartment,
  });
}