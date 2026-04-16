class MockDatabase {
  static final MockDatabase _instance = MockDatabase._internal();
  factory MockDatabase() => _instance;
  MockDatabase._internal();

  // DADOS GLOBAIS
  String userName = "kaiky";
  String userApartment = "Apto 102";
  String userEmail = "teste@ecoflow.com";
  String userPassword = "12345678";

  int userPoints = 1200; // Coloque uns 1200 pontos aqui para você conseguir testar o resgate!
  int userCollectionsMonth = 12;
  int userStreakDays = 5;

  // NOVO: Lista para guardar quais cupons já foram resgatados
  List<String> redeemedCoupons = []; 

  void addPoints(int points) {
    userPoints += points;
    userCollectionsMonth += 1;
  }
}