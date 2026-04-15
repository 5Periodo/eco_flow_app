class MockDatabase {
  static final MockDatabase _instance = MockDatabase._internal();
  factory MockDatabase() => _instance;
  MockDatabase._internal();

  String userName = "kaiky";
  String userApartment = "Apto 102";
  String userEmail = "teste@eco.com";
  String userPassword = "12345678";

  int userPoints = 75;
  int userCollectionsMonth = 12;
  int userStreakDays = 5;

  // Função para adicionar pontos e atualizar as coletas
  void addPoints(int points) {
    userPoints += points;
    userCollectionsMonth += 1;
  }
}