class Sale {
  final int? id;
  final double total;
  final DateTime date;

  Sale({
    this.id,
    required this.total,
    required this.date,
  });

  get productName => null;

  get quantity => null;

  get totalPrice => null;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'total': total,
      'date': date.toIso8601String(),
    };
  }

  static Sale fromMap(Map<String, dynamic> map) {
    return Sale(
      id: map['id'],
      total: map['total'],
      date: DateTime.parse(map['date']),
    );
  }
}
