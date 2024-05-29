import 'package:flutter/material.dart';
import '../models/sale.dart';
import '../services/dbbebidas.dart';

class SalesListScreen extends StatefulWidget {
  @override
  _SalesListScreenState createState() => _SalesListScreenState();
}

class _SalesListScreenState extends State<SalesListScreen> {
  List<Sale> _sales = [];

  @override
  void initState() {
    super.initState();
    _refreshSalesList();
  }

  Future<void> _refreshSalesList() async {
    final data = await DatabaseService().sales();
    setState(() {
      _sales = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ventas'),
      ),
      body: _sales.isEmpty
          ? Center(child: Text('No hay ventas registradas'))
          : ListView.builder(
        itemCount: _sales.length,
        itemBuilder: (context, index) {
          final sale = _sales[index];
          return ListTile(
            title: Text(sale.productName),
            subtitle: Text('Cantidad: ${sale.quantity}, Precio Total: \$${sale.totalPrice}'),
          );
        },
      ),
    );
  }
}
