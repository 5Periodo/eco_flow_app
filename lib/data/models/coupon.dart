class Coupon {
  final String id;
  final String title;
  final String benefit;
  final String description;
  final int cost;

  const Coupon({
    required this.id,
    required this.title,
    required this.benefit,
    required this.description,
    required this.cost,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
        id:          json['id']          as String,
        title:       json['title']       as String,
        benefit:     json['benefit']     as String,
        description: json['description'] as String,
        cost:        json['cost']        as int,
      );
}