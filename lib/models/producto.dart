class Product {
  final int? id;
  final String name;
  final double price;
  final int categoryId;
  final int supplierId;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.categoryId,
    required this.supplierId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'category_id': categoryId,
      'supplier_id': supplierId,
    };
  }

  static Product fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      categoryId: map['category_id'] ?? 0,
      supplierId: map['supplier_id'] ?? 0,
    );
  }
}

