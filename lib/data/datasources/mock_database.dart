class MockDatabase {
  static final MockDatabase _instance = MockDatabase._internal();
  factory MockDatabase() => _instance;
  MockDatabase._internal();

  // --- Estado privado ---
  String _userName            = 'kaiky';
  String _userApartment       = 'Apto 102';
  final String _userEmail     = 'teste@';
  final String _userPassword  = '12345678';

  int _userPoints             = 1200;
  int _userCollectionsMonth   = 12;
  int _userStreakDays          = 5;
  List<String> _redeemedCoupons = [];

  // --- Getters (leitura segura) ---
  String get userName           => _userName;
  String get userApartment      => _userApartment;
  String get userEmail          => _userEmail;
  String get userPassword       => _userPassword;
  int    get userPoints         => _userPoints;
  int    get userCollectionsMonth => _userCollectionsMonth;
  int    get userStreakDays      => _userStreakDays;

  /// Lista imutável — ninguém altera de fora
  List<String> get redeemedCoupons => List.unmodifiable(_redeemedCoupons);

  // --- Mutações controladas ---
  void addPoints(int points) {
    _userPoints += points;
    _userCollectionsMonth += 1;
  }

  void deductPoints(int points) {
    _userPoints -= points;
  }

  void addRedeemedCoupon(String id) {
    _redeemedCoupons.add(id);
  }

  /// Chamado ao registrar novo usuário
  void resetForNewUser({required String name, required String apartment}) {
    _userName             = name;
    _userApartment        = apartment;
    _userPoints           = 0;
    _userCollectionsMonth = 0;
    _userStreakDays        = 1;
    _redeemedCoupons      = [];
  }
}