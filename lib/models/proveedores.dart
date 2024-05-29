class Supplier {
  final int? id;
  final String name;

  Supplier({this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
