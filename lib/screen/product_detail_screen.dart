import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../models/categoria.dart';
import '../models/proveedores.dart';
import '../services/dbbebidas.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product? product;

  ProductDetailScreen({this.product});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late Future<List<Category>> futureCategories;
  late Future<List<Supplier>> futureSuppliers;
  int? _selectedCategoryId;
  int? _selectedSupplierId;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name);
    _priceController = TextEditingController(text: widget.product?.price.toString());
    futureCategories = DatabaseService().categories();
    futureSuppliers = DatabaseService().suppliers();
    _selectedCategoryId = widget.product?.categoryId;
    _selectedSupplierId = widget.product?.supplierId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Crear Producto' : 'Editar Producto'),
        actions: widget.product != null
            ? [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              await DatabaseService().deleteProduct(widget.product!.id!);
              Navigator.pop(context, true);
            },
          ),
        ]
            : [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese un nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese un precio';
                  }
                  return null;
                },
              ),
              FutureBuilder<List<Category>>(
                future: futureCategories,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return DropdownButtonFormField<int>(
                      decoration: InputDecoration(labelText: 'Categoria'),
                      value: _selectedCategoryId,
                      items: snapshot.data!.map((category) {
                        return DropdownMenuItem<int>(
                          value: category.id,
                          child: Text(category.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategoryId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Selecione una categoria';
                        }
                        return null;
                      },
                    );
                  }
                },
              ),
              FutureBuilder<List<Supplier>>(
                future: futureSuppliers,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return DropdownButtonFormField<int>(
                      decoration: InputDecoration(labelText: 'Proveedor'),
                      value: _selectedSupplierId,
                      items: snapshot.data!.map((supplier) {
                        return DropdownMenuItem<int>(
                          value: supplier.id,
                          child: Text(supplier.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedSupplierId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Seleccione un proveedor';
                        }
                        return null;
                      },
                    );
                  }
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final product = Product(
                      id: widget.product?.id,
                      name: _nameController.text,
                      price: double.parse(_priceController.text),
                      categoryId: _selectedCategoryId!,
                      supplierId: _selectedSupplierId!,
                    );

                    if (widget.product == null) {
                      await DatabaseService().insertProduct(product);
                    } else {
                      await DatabaseService().updateProduct(product);
                    }

                    Navigator.pop(context, true);
                  }
                },
                child: Text(widget.product == null ? 'Crear' : 'Actualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
