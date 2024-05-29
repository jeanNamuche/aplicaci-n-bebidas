class SaleItem {
  final int productId;
  final String productName;
  final double productPrice;
  int quantity;

  SaleItem({
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.quantity,
  });



  double get totalPrice => productPrice * quantity;

  static SaleItem fromMap(Map<String, dynamic> map) {
    return SaleItem(
      productId: map['productId'],
      productName: map['productName'],
      productPrice: map['productPrice'],
      quantity: map['quantity'],

    );
  }


}


