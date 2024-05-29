import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../models/sale_item.dart';
import '../services/dbbebidas.dart';

class SaleScreen extends StatefulWidget {
  @override
  _SaleScreenState createState() => _SaleScreenState();
}

class _SaleScreenState extends State<SaleScreen> {
  final List<SaleItem> _saleItems = [];
  final TextEditingController _searchController = TextEditingController();
  List<Product> _searchResults = [];

  void _addProductToSale(Product product) {
    final existingItem = _saleItems.firstWhere(
            (item) => item.productId == product.id, orElse: () => SaleItem(
      productId: product.id!,
      productName: product.name,
      productPrice: product.price,
      quantity: 0,
    ));

    if (existingItem.quantity > 0) {
      setState(() {
        existingItem.quantity++;
      });
    } else {
      setState(() {
        _saleItems.add(SaleItem(
          productId: product.id!,
          productName: product.name,
          productPrice: product.price,
          quantity: 1,
        ));
      });
    }
  }

  double _calculateTotal() {
    return _saleItems.fold(0, (total, item) => total + item.totalPrice);
  }

  int _calculateTotalQuantity() {
    return _saleItems.fold(0, (total, item) => total + item.quantity);
  }

  void _completeSale() async {
    // Aquí añadirías la lógica para guardar la venta en la base de datos
    setState(() {
      _saleItems.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Venta completada con éxito!'),
    ));
  }

  void _searchProducts(String query) async {
    final results = await DatabaseService().searchProducts(query);
    setState(() {
      _searchResults = results;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nueva Venta'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar Producto',
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: _searchProducts,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final product = _searchResults[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => _addProductToSale(product),
                  ),
                );
              },
            ),
          ),
          Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: _saleItems.length,
              itemBuilder: (context, index) {
                final item = _saleItems[index];
                return ListTile(
                  title: Text(item.productName),
                  subtitle: Text('Cantidad: ${item.quantity}'),
                  trailing: Text('\$${item.totalPrice.toStringAsFixed(2)}'),
                  leading: IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      setState(() {
                        if (item.quantity > 1) {
                          item.quantity--;
                        } else {
                          _saleItems.removeAt(index);
                        }
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total: \$${_calculateTotal().toStringAsFixed(2)}'),
                Text('Items: ${_calculateTotalQuantity()}'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _completeSale,
              child: Text('Completar Venta'),
            ),
          ),
        ],
      ),
    );
  }
}
