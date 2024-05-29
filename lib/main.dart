import 'package:flutter/material.dart';
import 'screen/categori_list_screen.dart';
import 'screen/supplier_list_screen.dart';
import 'screen/product_list_screen.dart';
import 'screen/sales_list_screen.dart';
import 'screen/sale_screen.dart'; // Asegúrate de importar SaleScreen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maria de los Ángeles',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      routes: {
        '/categories': (context) => CategoryListScreen(),
        '/suppliers': (context) => SupplierListScreen(),
        '/products': (context) => ProductListScreen(),
        '/sales': (context) => SalesListScreen(),
        '/sale': (context) => SaleScreen(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maria de los Ángeles'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/categories');
              },
              child: Text('Categorías'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/suppliers');
              },
              child: Text('Proveedores'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/products');
              },
              child: Text('Productos'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/sales');
              },
              child: Text('Ventas'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/sale');
              },
              child: Text('Ver Ventas'),
            ),
          ],
        ),
      ),
    );
  }
}
