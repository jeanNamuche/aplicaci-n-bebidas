import 'package:flutter/material.dart';
import '../models/proveedores.dart';
import '../services/dbbebidas.dart';

class SupplierDetailScreen extends StatefulWidget {
  final Supplier? supplier;

  SupplierDetailScreen({this.supplier});

  @override
  _SupplierDetailScreenState createState() => _SupplierDetailScreenState();
}

class _SupplierDetailScreenState extends State<SupplierDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.supplier?.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.supplier == null ? 'Crear Proveedores' : 'Editar Proveedores'),
        actions: widget.supplier != null
            ? [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              await DatabaseService().deleteSupplier(widget.supplier!.id!);
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final supplier = Supplier(
                      id: widget.supplier?.id,
                      name: _nameController.text,
                    );

                    if (widget.supplier == null) {
                      await DatabaseService().insertSupplier(supplier);
                    } else {
                      await DatabaseService().updateSupplier(supplier);
                    }

                    Navigator.pop(context, true);
                  }
                },
                child: Text(widget.supplier == null ? 'Crear' : 'Actualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
