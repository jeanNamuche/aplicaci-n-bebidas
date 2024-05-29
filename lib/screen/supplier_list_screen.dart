import 'package:flutter/material.dart';
import '../models/proveedores.dart';
import '../services/dbbebidas.dart';
import 'supplier_detail_screen.dart';

class SupplierListScreen extends StatefulWidget {
  @override
  _SupplierListScreenState createState() => _SupplierListScreenState();
}

class _SupplierListScreenState extends State<SupplierListScreen> {
  late Future<List<Supplier>> futureSuppliers;

  @override
  void initState() {
    super.initState();
    futureSuppliers = DatabaseService().suppliers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Proveedores'),
      ),
      body: FutureBuilder<List<Supplier>>(
        future: futureSuppliers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No suppliers found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final supplier = snapshot.data![index];
                return ListTile(
                  title: Text(supplier.name),
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SupplierDetailScreen(supplier: supplier),
                      ),
                    );
                    if (result == true) {
                      setState(() {
                        futureSuppliers = DatabaseService().suppliers();
                      });
                    }
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SupplierDetailScreen(),
            ),
          );
          if (result == true) {
            setState(() {
              futureSuppliers = DatabaseService().suppliers();
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
